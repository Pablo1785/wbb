from .serializers import ProfileSerializer, SubAccountSerializer, BankDepositSerializer, TransactionSerializer, BitcoinTransactionSerializer
from .models import Profile, SubAccount, BankDeposit, Transaction, BitcoinTransaction
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.http import Http404

# Create your views here.


class ProfileListView(APIView):
    """
    List all profiles, or create a new profile.
    """

    def get(self, request, format=None):
        profiles = Profile.objects.all()
        serializer = ProfileSerializer(profiles, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = ProfileSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        profile = self.get_object(pk)
        profile.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ProfileDetailView(APIView):
    """
    Retrieve, update or delete a profile instance.
    """

    def get_object(self, pk):
        try:
            return Profile.objects.get(pk=pk)
        except Profile.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        profile = self.get_object(pk)
        profile = ProfileSerializer(profile)
        return Response(profile.data)

    def put(self, request, pk, format=None):
        profile = self.get_object(pk)
        serializer = ProfileSerializer(profile, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        profile = self.get_object(pk)
        profile.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class SubAccountListView(APIView):
    """
    List all subaccounts, or create a new subaccount.
    """

    def get(self, request, format=None):
        subaccounts = SubAccount.objects.all()
        serializer = SubAccountSerializer(subaccounts, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = SubAccountSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        subaccount = self.get_object(pk)
        subaccount.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class SubAccountDetailView(APIView):
    """
    Retrieve, update or delete a subaccount instance.
    """

    def get_object(self, pk):
        try:
            return SubAccount.objects.get(pk=pk)
        except SubAccount.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        subaccount = self.get_object(pk)
        subaccount = SubAccountSerializer(subaccount)
        return Response(subaccount.data)

    def put(self, request, pk, format=None):
        subaccount = self.get_object(pk)
        serializer = SubAccountSerializer(subaccount, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        subaccount = self.get_object(pk)
        subaccount.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BankDepositListView(APIView):
    """
    List all bank deposits, or create a new bank deposit.
    """

    def get(self, request, format=None):
        bank_deposits = BankDeposit.objects.all()
        serializer = BankDepositSerializer(bank_deposits, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = BankDepositSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        bank_deposit = self.get_object(pk)
        bank_deposit.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BankDepositDetailView(APIView):
    """
    Retrieve, update or delete a bank deposit instance.
    """

    def get_object(self, pk):
        try:
            return BankDeposit.objects.get(pk=pk)
        except BankDeposit.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        bank_deposit = self.get_object(pk)
        bank_deposit = BankDepositSerializer(bank_deposit)
        return Response(bank_deposit.data)

    def put(self, request, pk, format=None):
        bank_deposit = self.get_object(pk)
        serializer = BankDepositSerializer(bank_deposit, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        bank_deposit = self.get_object(pk)
        bank_deposit.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class TransactionListView(APIView):
    """
    List all transactions, or create a new transaction.
    """

    def get(self, request, format=None):
        transactions = Transaction.objects.all()
        serializer = TransactionSerializer(transactions, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = TransactionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        transaction = self.get_object(pk)
        transaction.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class TransactionDetailView(APIView):
    """
    Retrieve, update or delete a transaction instance.
    """

    def get_object(self, pk):
        try:
            return Transaction.objects.get(pk=pk)
        except Transaction.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        transaction = self.get_object(pk)
        transaction = TransactionSerializer(transaction)
        return Response(transaction.data)

    def put(self, request, pk, format=None):
        transaction = self.get_object(pk)
        serializer = TransactionSerializer(transaction, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        transaction = self.get_object(pk)
        transaction.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BitcoinTransactionListView(APIView):
    """
    List all bitcoin transactions, or create a new bitcoin transaction.
    """

    def get(self, request, format=None):
        btc_transactions = BitcoinTransaction.objects.all()
        serializer = BitcoinTransactionSerializer(btc_transactions, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = BitcoinTransactionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        btc_transaction = self.get_object(pk)
        btc_transaction.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BitcoinTransactionDetailView(APIView):
    """
    Retrieve, update or delete a bitcoin transaction instance.
    """

    def get_object(self, pk):
        try:
            return BitcoinTransaction.objects.get(pk=pk)
        except BitcoinTransaction.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        btc_transaction = self.get_object(pk)
        btc_transaction = BitcoinTransactionSerializer(btc_transaction)
        return Response(btc_transaction.data)

    def put(self, request, pk, format=None):
        btc_transaction = self.get_object(pk)
        serializer = BitcoinTransactionSerializer(
            btc_transaction, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        transaction = self.get_object(pk)
        transaction.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
