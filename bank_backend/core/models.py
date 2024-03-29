from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.signals import user_logged_in
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils.crypto import get_random_string
from datetime import timedelta
# we are using testnet, for mainnet replace with 'from bit import Key'
from bit import PrivateKeyTestnet as Key

DEFAULT_SLUG_LENGTH = 15


@receiver(post_save, sender=User)
def create_wallet_and_subaccount_with_user(sender, instance, created, **kwargs):
    if created:
        key = Key()
        pk = key.to_wif()
        wa = key.address
        Wallet.objects.create(owner=instance, private_key=pk, wallet_address=wa)
        SubAccount.objects.create(owner=instance)


class Wallet(models.Model):
    owner = models.OneToOneField(
        User, on_delete=models.CASCADE, primary_key=True)
    private_key = models.CharField(max_length=52)  # WIF format
    wallet_address = models.CharField(max_length=34)


class SubAccount(models.Model):
    sub_address = models.SlugField(max_length=DEFAULT_SLUG_LENGTH, default='')

    # Having a Wallet object you can access its SubAccounts with Wallet.subaccount_set.all()
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    balance = models.DecimalField(max_digits=22, decimal_places=9, blank=True, default=0)

    def save(self, *args, **kwargs):
        """ Add Slug creating/checking to save method. """
        slug_save(self) # call slug_save, listed below
        super(SubAccount, self).save(*args, **kwargs)


def slug_save(obj, slug_len=DEFAULT_SLUG_LENGTH, allowed_chars="0123456789"):
    """ A function to generate a slug_len character slug and see if it has been used and contains naughty words."""
    if not obj.sub_address: # if there isn't a slug
        obj.sub_address = get_random_string(slug_len, allowed_chars=allowed_chars) # create one
        slug_is_wrong = True  
        while slug_is_wrong: # keep checking until we have a valid slug
            slug_is_wrong = False
            other_objs_with_slug = type(obj).objects.filter(sub_address=obj.sub_address)
            if len(other_objs_with_slug) > 0:
                # if any other objects have current slug
                slug_is_wrong = True
            if slug_is_wrong:
                # create another slug and check it again
                obj.sub_address = get_random_string(slug_len, allowed_chars=allowed_chars)


class BankDeposit(models.Model):

    # Having a SubAccount object you can access its BankDeposit info with SubAccount.bankdeposit; 
    # CAREFUL! Accessing BankDeposit of a SubAccount that is not a deposit will throw ObjectDoesNotExist! This is intended behaviour!
    # Accessing SubAccount.bankdeposit throws ObjectDoesNotExist, which tells us this is not a Deposit account
    account = models.OneToOneField(
        SubAccount, on_delete=models.CASCADE, primary_key=True)
    interest_rate = models.DecimalField(default=0.314, max_digits=5, decimal_places=3)  # Always present, set to default
    start_date = models.DateTimeField(auto_now=True)  # Always present, set to default
    deposit_period = models.DurationField(default=timedelta(seconds=35))  # Always present, set to default
    capitalization_period = models.DurationField(blank=True, null=True)  # Capitalization is optional
    last_capitalization = models.DateTimeField(blank=True, null=True)    # Capitalization is optional
    title = models.CharField(max_length=256)


class Transaction(models.Model):

    # Having a SubAccount objects you can access its related transactions with SubAccount.(outgoing/incoming)_transactions.all()
    source_id = models.ForeignKey(SubAccount, on_delete=models.PROTECT, related_name='outgoing_transactions', blank=True, null=True)
    target_id = models.ForeignKey(SubAccount, on_delete=models.PROTECT, related_name='incoming_transactions', blank=True, null=True)
    
    source = models.CharField(max_length=34, blank=True, null=True)
    target = models.CharField(max_length=34, blank=True, null=True)

    amount = models.DecimalField(max_digits=22, decimal_places=9)

    send_time = models.DateTimeField(auto_now=True)
    confirmation_time = models.DateTimeField(blank=True, null=True)
    title = models.CharField(max_length=256)
    fee = models.DecimalField(max_digits=22, decimal_places=15, blank=True, null=True)  # Nullable, miner/bank fee for the transaction
    transaction_hash = models.CharField(max_length=64, blank=True, null=True)  # Nullable, blockchain ID of the transaction

    def save(self, *args, **kwargs):
        source_acc = SubAccount.objects.get(sub_address=self.source)
        try:
            target_acc = SubAccount.objects.get(sub_address=self.target)
            flag = True
            target_address = Wallet.objects.get(owner=target_acc.owner).wallet_address
        except SubAccount.DoesNotExist:
            flag = False
            target_address = self.target
        if flag and source_acc.owner == target_acc.owner:
            trans_slug_save(self, allowed_chars="abcdefghijklmnoqprstuvwxyz0123456789")
            source_acc.balance -= self.amount
            source_acc.save()
            target_acc.balance += self.amount
            target_acc.save()
        else:
            source_wallet = Wallet.objects.get(owner=source_acc.owner)
            source_key = Key(source_wallet.private_key)
            
            fee = None if self.fee is None else self.fee * 10**8 # fee needs to be in satoshis
            self.transaction_hash = source_key.send([(target_address, self.amount, 'btc')], fee=int(fee))
            from core.tasks import check_transaction_confirmed
            check_transaction_confirmed.delay(self.transaction_hash)

        self.source_id = source_acc
        try:
            self.target_id = target_acc
        except UnboundLocalError:
            pass
        super(Transaction, self).save(*args, **kwargs)

def trans_slug_save(obj, slug_len=DEFAULT_SLUG_LENGTH, allowed_chars="0123456789"):
    """ A function to generate a slug_len character slug and see if it has been used and contains naughty words."""
    if not obj.transaction_hash: # if there isn't a slug
        obj.transaction_hash = get_random_string(slug_len, allowed_chars=allowed_chars) # create one
        slug_is_wrong = True  
        while slug_is_wrong: # keep checking until we have a valid slug
            slug_is_wrong = False
            other_objs_with_slug = type(obj).objects.filter(transaction_hash=obj.transaction_hash)
            if len(other_objs_with_slug) > 0:
                # if any other objects have current slug
                slug_is_wrong = True
            if slug_is_wrong:
                # create another slug and check it again
                obj.transaction_hash = get_random_string(slug_len, allowed_chars=allowed_chars)


class LoginRecord(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    action = models.CharField(max_length=64)
    date = models.DateTimeField(auto_now=True)
    ip_address = models.GenericIPAddressField(null=True)


@receiver(user_logged_in)
def user_logged_in_callback(sender, request, user, **kwargs):
    ip = request.META.get('REMOTE_ADDR')
    LoginRecord.objects.create(user=user, action='user_logged_in', ip_address=ip)
