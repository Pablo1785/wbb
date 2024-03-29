from core import views
from django.urls import path


urlpatterns = [
    path('user/', views.UserListView.as_view()),
    path('user/<username>/', views.UserDetailView.as_view()),
    path('wallet/', views.WalletListView.as_view()),
    path('subacc/', views.SubAccountListView.as_view()),
    path('subacc/<sub_address>/', views.SubAccountDetailView.as_view()),
    path('deposit/', views.BankDepositListView.as_view()),
    path('deposit/<sub_address>/', views.BankDepositDetailView.as_view()),
    path('trans/', views.TransactionListView.as_view()),
    path('trans/in/', views.TransactionIncomingListView.as_view()),
    path('trans/out/', views.TransactionOutgoingListView.as_view()),
    path('trans/<transaction_hash>/', views.TransactionDetailView.as_view()),
    path('login_history/', views.LoginRecordListView.as_view()),
]