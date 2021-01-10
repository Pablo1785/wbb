from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

# Create your models here.


class Profile(models.Model):
    owner = models.OneToOneField(
        User, on_delete=models.CASCADE, primary_key=True)
    private_key = models.CharField(max_length=52)  # WIF format
    wallet_address = models.CharField(max_length=34)


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(owner=instance)


@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()


class SubAccount(models.Model):
    sub_address = models.CharField(max_length=32, primary_key=True)

    # Having a Profile object you can access its SubAccounts with Profile.subaccount_set.all()
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    balance = models.DecimalField(max_digits=22, decimal_places=9, blank=True, default=0)
    currency = models.CharField(max_length=3)
    


class BankDeposit(models.Model):

    # Having a SubAccount object you can access its BankDeposit info with SubAccount.bankdeposit; 
    # CAREFUL! Accessing BankDeposit of a SubAccount that is not a deposit will throw ObjectDoesNotExist! This is intended behaviour!
    # Accessing SubAccount.bankdeposit throws ObjectDoesNotExist, which tells us this is not a Deposit account
    account = models.OneToOneField(
        SubAccount, on_delete=models.CASCADE, primary_key=True)
    interest_rate = models.DecimalField(max_digits=5, decimal_places=3)
    start_date = models.DateTimeField()
    deposit_period = models.DurationField()
    capitalization_period = models.DurationField()
    last_capitalization = models.DateTimeField()
    title = models.CharField(max_length=256)


class Transaction(models.Model):

    # Having a SubAccount objects you can access its related transactions with SubAccount.transaction_set.all()
    source = models.ForeignKey(SubAccount, on_delete=models.PROTECT)
    target = models.ForeignKey(SubAccount, on_delete=models.PROTECT)

    amount = models.DecimalField(max_digits=22, decimal_places=9)

    currency = models.CharField(max_length=3)
    send_time = models.DateTimeField()
    confirmation_time = models.DateTimeField()
    title = models.CharField(max_length=256)
    fee = models.DecimalField(max_digits=22, decimal_places=15)  # Nullable, miner/bank fee for the transaction
    transaction_hash = models.CharField(max_lenth=256)  # Nullable, blockchain ID of the transaction

