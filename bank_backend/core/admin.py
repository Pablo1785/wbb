from django.contrib import admin
from .models import Profile, SubAccount, BankDeposit, Transaction, BitcoinTransaction

# Register your models here.
admin.site.register(Profile)
admin.site.register(SubAccount)
admin.site.register(BankDeposit)
admin.site.register(Transaction)