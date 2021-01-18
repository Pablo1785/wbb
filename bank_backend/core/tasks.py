from __future__ import absolute_import, unicode_literals
from bank_backend.celery import app

from django.contrib.auth.models import User
from core.models import Transaction, SubAccount, Wallet

from datetime import datetime
import requests
from decimal import Decimal
# we are using testnet, for mainnet replace with 'from bit import Key'
from bit import PrivateKeyTestnet as Key
from django.db.models import ObjectDoesNotExist
from django.utils import timezone


class TxNotConfirmedException(Exception):
  pass

@app.task(bind=True, autoretry_for=(TxNotConfirmedException,), retry_kwargs={'max_retries': 7, 'countdown': 5})
def check_transaction_confirmed(self, transaction_hash):
    try:
        fees = requests.get("https://api.blockcypher.com/v1/btc/test3/txs/"+transaction_hash).json()['fees']
    except KeyError:
        raise TxNotConfirmedException()  # task failed - raise exception

    transaction = Transaction.objects.get(transaction_hash=transaction_hash)
    source_account = SubAccount.objects.get(sub_address=transaction.source)
    source_account.balance -= transaction.amount + Decimal(fees*10**-8)
    source_account.save()

    try:
        target_account = SubAccount.objects.get(sub_address=transaction.target)
        target_account.balance += transaction.amount
        target_account.save()
    except SubAccount.DoesNotExist:
        pass

@app.task
def check_balance():
    wallets = Wallet.objects.all()
    for w in wallets:
        subaccounts = SubAccount.objects.filter(owner=w.owner)
        balance_sum = 0
        for s in subaccounts:
            balance_sum += s.balance
        key = Key(w.private_key)
        true_balance = Decimal(key.get_balance('btc'))

        if true_balance > balance_sum:
            try:
                subaccounts[0].balance += true_balance - balance_sum
                subaccounts[0].save()
            except IndexError:
                pass
        elif true_balance < balance_sum:
            for s in subaccounts:
                if balance_sum - s.balance == true_balance:
                    s.balance = 0
                elif balance_sum - s.balance  < true_balance:
                    s.balance -= balance_sum - true_balance
                    s.save()
                    break
                else:
                    balance_sum -= s.balance
                    s.balance = 0
                    s.save()


@app.task
def check_deposit():
    subaccounts = subaccounts = SubAccount.objects.all()
    for s in subaccounts:
        try:
            d = s.bankdeposit
            if d.start_date + d.deposit_period < timezone.now() and d.last_capitalization is None:
                try:
                    periods_number = d.deposit_period/d.capitalization_period
                except TypeError:
                    periods_number = 1
                # TODO: proper bitcoin transaction
                s.balance = s.balance * (1+d.interest_rate)**periods_number
                d.last_capitalization = timezone.now()
                s.save()
                d.save()
        except ObjectDoesNotExist:
            pass