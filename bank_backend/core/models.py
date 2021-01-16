from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.signals import user_logged_in
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils.crypto import get_random_string
from datetime import timedelta

DEFAULT_SLUG_LENGTH = 15


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
    sub_address = models.SlugField(max_length=DEFAULT_SLUG_LENGTH, default='')

    # Having a Profile object you can access its SubAccounts with Profile.subaccount_set.all()
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    balance = models.DecimalField(max_digits=22, decimal_places=9, blank=True, default=0)
    currency = models.CharField(max_length=3)

    def save(self, *args, **kwargs):
        """ Add Slug creating/checking to save method. """
        slug_save(self) # call slug_save, listed below
        super(SubAccount, self).save(*args, **kwargs)


def slug_save(obj):
    """ A function to generate a DEFAULT_SLUG_LENGTH character slug and see if it has been used and contains naughty words."""
    if not obj.sub_address: # if there isn't a slug
        obj.sub_address = get_random_string(DEFAULT_SLUG_LENGTH, allowed_chars="0123456789") # create one
        slug_is_wrong = True  
        while slug_is_wrong: # keep checking until we have a valid slug
            slug_is_wrong = False
            other_objs_with_slug = type(obj).objects.filter(sub_address=obj.sub_address)
            if len(other_objs_with_slug) > 0:
                # if any other objects have current slug
                slug_is_wrong = True
            if slug_is_wrong:
                # create another slug and check it again
                obj.sub_address = get_random_string(DEFAULT_SLUG_LENGTH, allowed_chars="0123456789")


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

    # Having a SubAccount objects you can access its related transactions with SubAccount.(outgoing/incoming)_set.all()
    source = models.ForeignKey(SubAccount, on_delete=models.PROTECT, related_name='outgoing', blank=True, null=True)
    target = models.ForeignKey(SubAccount, on_delete=models.PROTECT, related_name='incoming', blank=True, null=True)

    amount = models.DecimalField(max_digits=22, decimal_places=9)

    currency = models.CharField(max_length=3)
    send_time = models.DateTimeField(auto_now=True)
    confirmation_time = models.DateTimeField(blank=True, null=True)
    title = models.CharField(max_length=256)
    fee = models.DecimalField(max_digits=22, decimal_places=15, blank=True, null=True)  # Nullable, miner/bank fee for the transaction
    transaction_hash = models.CharField(max_length=256, blank=True, null=True)  # Nullable, blockchain ID of the transaction


class LoginRecord(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    action = models.CharField(max_length=64)
    date = models.DateTimeField(auto_now=True)
    ip_address = models.GenericIPAddressField(null=True)


@receiver(user_logged_in)
def user_logged_in_callback(sender, request, user, **kwargs):
    ip = request.META.get('REMOTE_ADDR')
    LoginRecord.objects.create(user=user, action='user_logged_in', ip_address=ip)
