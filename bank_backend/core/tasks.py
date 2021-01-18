from __future__ import absolute_import, unicode_literals
from bank_backend.celery import app

from django.contrib.auth.models import User
from core.models import Transaction, SubAccount

from datetime import datetime
import requests
from decimal import Decimal

class TxNotConfirmedException(Exception):
  pass

@app.task(bind=True, autoretry_for=(TxNotConfirmedException,), retry_kwargs={'max_retries': 7, 'countdown': 5})
def check_transaction_confirmed(self, transaction_hash):
    print("siema")
    try:
        fees = requests.get("https://api.blockcypher.com/v1/btc/test3/txs/"+transaction_hash).json()['fees']
    except KeyError:
        raise TxNotConfirmedException()  # task failed - raise exception

    print("pyklo")

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

"""
Uruchomienie taska:

from core.tasks import *

task_func.delay(args=(transaction,))
"""
