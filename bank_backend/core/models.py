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
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    balance = models.DecimalField(max_digits=22, decimal_places=9, blank=True, default=0)
    currency = models.CharField(max_length=3)
    sub_address = models.CharField(max_length=32)
    deposit_status = models.BooleanField(default=False)


class BankDeposit(models.Model):
    account = models.OneToOneField(
        SubAccount, on_delete=models.CASCADE, primary_key=True)
    interest_rate = models.DecimalField(max_digits=5, decimal_places=3)
    start_date = models.DateTimeField()
    deposit_period = models.DurationField()
    capitalization_period = models.DurationField()
    last_capitalization = models.DateTimeField()
    title = models.CharField(max_length=256)


class Transaction(models.Model):
    account = models.ForeignKey(SubAccount, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=22, decimal_places=9)
    currency = models.CharField(max_length=3, choices=(('EUR', 'Euro'), ('BTC', 'Bitcoin')))
    source_address = models.CharField(max_length=32)
    target_address = models.CharField(max_length=32)
    timestamp = models.DateTimeField()
    send_time = models.DateTimeField()
    confirmation_time = models.DateTimeField()
    title = models.CharField(max_length=256)


class BitcoinTransaction(models.Model):
    account = models.OneToOneField(
        Transaction, on_delete=models.CASCADE, primary_key=True)
    source_address = models.CharField(max_length=34)
    target_address = models.CharField(max_length=34)
    amount = models.DecimalField(max_digits=22, decimal_places=9)
    miner_fee = models.DecimalField(max_digits=22, decimal_places=9)
