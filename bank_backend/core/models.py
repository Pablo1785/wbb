from django.db import models

# Create your models here.


class User(models.Model):
    username = models.CharField(max_length=25)
    password = models.CharField(max_length=256)
    email = models.EmailField()
    private_key = models.CharField(max_length=52)  # WIF format
    wallet_address = models.CharField(max_length=34)


class SubAccount(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    balance = models.DecimalField(max_digits=22, decimal_places=9)
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
    currency = models.CharField(max_length=3)
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

