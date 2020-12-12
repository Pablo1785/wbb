from django.urls import path
from .views import ProfileView, SubAccountView, BankDepositView, TransactionView, BitcoinTransactionView


urlpatterns = [
    path('profile', ProfileView.as_view()),
    path('subaccount', SubAccountView.as_view()),
    path('deposit', BankDepositView.as_view()),
    path('transaction', TransactionView.as_view()),
    path('btctransaction', BitcoinTransactionView.as_view()),
]