from django.contrib import admin
from .models import Wallet, SubAccount, BankDeposit, Transaction

# Register your models here.
admin.site.register(Wallet)
admin.site.register(SubAccount)
admin.site.register(BankDeposit)
admin.site.register(Transaction)