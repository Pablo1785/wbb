from django.shortcuts import render
from rest_framework import generics
from .serializers import ProfileSerializer, SubAccountSerializer, BankDepositSerializer, TransactionSerializer, BitcoinTransactionSerializer
from .models import Profile, SubAccount, BankDeposit, Transaction, BitcoinTransaction


# Create your views here.
class ProfileView(generics.ListAPIView):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer


class SubAccountView(generics.ListAPIView):
    queryset = SubAccount.objects.all()
    serializer_class = SubAccountSerializer


class BankDepositView(generics.ListAPIView):
    queryset = BankDeposit.objects.all()
    serializer_class = BankDepositSerializer


class TransactionView(generics.ListAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer


class BitcoinTransactionView(generics.ListAPIView):
    queryset = BitcoinTransaction.objects.all()
    serializer_class = BitcoinTransactionSerializer
