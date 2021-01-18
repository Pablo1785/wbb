from .serializers import UserSerializer, WalletSerializer, FullWalletSerializer, SubAccountSerializer, BankDepositSerializer, TransactionSerializer, LoginRecordSerializer
from .models import Wallet, SubAccount, BankDeposit, Transaction, LoginRecord
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.http import Http404, HttpResponse
from django.contrib.auth.models import User
from django.db.models import Q
# we are using testnet, for mainnet replace with 'from bit import Key'
from bit import PrivateKeyTestnet as Key


# Display static html
import os
from bank_backend.settings import BASE_DIR, STATIC_URL
from django.shortcuts import render
from django.views.decorators.clickjacking import xframe_options_exempt

# Create your views here.


class UserListView(APIView):
    """
    List all users, or create a new user.
    """

    def get(self, request, format=None):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserDetailView(APIView):
    """
    Retrieve, update or delete an user instance.
    """

    def get_object(self, username):
        try:
            return User.objects.get(username=username)
        except User.DoesNotExist:
            raise Http404

    def get(self, request, username, format=None):
        user = self.get_object(username)
        user = UserSerializer(user)
        return Response(user.data)

    def put(self, request, username, format=None, partial=True):
        user = self.get_object(username)
        serializer = UserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, username, format=None):
        user = self.get_object(username)
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class WalletListView(APIView):
    def get(self, request, format=None):
        try:
            wallet = Wallet.objects.get(owner=request.user)
        except Wallet.DoesNotExist:
            raise Http404
        wallet = WalletSerializer(wallet)
        return Response(wallet.data)

    def post(self, request, format=None):
        if Wallet.objects.filter(owner=request.user).exists():
            return Response("User already has private key assigned", status=status.HTTP_400_BAD_REQUEST)
        
        if 'private_key' not in request.data:
            key = Key()
            request.data['private_key'] = key.to_wif()
        else:
            try:
                key = Key(request.data['private_key'])
            except ValueError:
                return Response("Private key provided is not valid", status=status.HTTP_400_BAD_REQUEST)

        
        if Wallet.objects.filter(private_key=request.data["private_key"]).exists():
            return Response("This private key is already registered", status=status.HTTP_400_BAD_REQUEST)
        
        request.data['wallet_address'] = key.address
        request.data['owner'] = request.user.id
        serializer = FullWalletSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SubAccountListView(APIView):
    """
    List all subaccounts, or create a new subaccount.
    """
    
    def get(self, request, format=None):
        subaccounts = SubAccount.objects.filter(owner=request.user)
        serializer = SubAccountSerializer(subaccounts, many=True)
        modified_data = serializer.data
        for ordered_dict in modified_data:  # return usernames instead of ids
            ordered_dict["owner"] = str(request.user)
        return Response(modified_data)

    def post(self, request, format=None):
        request.data['owner'] = request.user.id
        serializer = SubAccountSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            modified_data = serializer.data
            modified_data['owner'] = str(request.user)  # return username instead of id
            return Response(modified_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, format=None):
        subaccount = self.get_object(request)
        subaccount.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class SubAccountDetailView(APIView):
    """
    Retrieve, update or delete a subaccount instance.
    """

    def get_object(self, sub_address):
        try:
            return SubAccount.objects.get(sub_address=sub_address)
        except SubAccount.DoesNotExist:
            raise Http404

    def get(self, request, sub_address, format=None):
        subaccount = self.get_object(sub_address)
        subaccount = SubAccountSerializer(subaccount)
        return Response(subaccount.data)

    def put(self, request, sub_address, format=None):
        subaccount = self.get_object(sub_address)
        serializer = SubAccountSerializer(subaccount, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, sub_address, format=None):
        subaccount = self.get_object(sub_address)
        subaccount.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BankDepositListView(APIView):
    """
    List all bank deposits, or create a new bank deposit.
    """

    def get(self, request, format=None):
        subaccounts = SubAccount.objects.filter(owner=request.user)
        bank_deposits = BankDeposit.objects.filter(account__owner=request.user)
        serializer = BankDepositSerializer(bank_deposits, many=True)
        modified_data = serializer.data
        for ordered_dict in modified_data:  # return sub_addresses instead of ids
            ordered_dict["account"] = str(SubAccount.objects.get(id=ordered_dict["account"]).sub_address)
        return Response(modified_data)

    def post(self, request, format=None):
        try:
            request.data["account"] = SubAccount.objects.get(sub_address=request.data["account"]).id
        except KeyError:
            return Response("Missing account field", status=status.HTTP_400_BAD_REQUEST)

        serializer = BankDepositSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            modified_data = serializer.data
            modified_data["account"] = str(SubAccount.objects.get(id=serializer.data["account"]).sub_address)
            return Response(modified_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, transaction_hash, format=None):
        bank_deposit = self.get_object(transaction_hash)
        bank_deposit.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BankDepositDetailView(APIView):
    """
    Retrieve, update or delete a bank deposit instance.
    """

    def get_object(self, sub_address):
        try:
            account = SubAccount.objects.get(sub_address=sub_address)
            return BankDeposit.objects.get(account=account)
        except BankDeposit.DoesNotExist:
            raise Http404

    def get(self, request, sub_address, format=None):
        bank_deposit = self.get_object(sub_address)
        bank_deposit = BankDepositSerializer(bank_deposit)
        return Response(bank_deposit.data)

    def put(self, request, sub_address, format=None):
        bank_deposit = self.get_object(sub_address)
        serializer = BankDepositSerializer(bank_deposit, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, sub_address, format=None):
        bank_deposit = self.get_object(sub_address)
        bank_deposit.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class TransactionListView(APIView):
    """
    List all transactions, or create a new transaction.
    """

    def get(self, request, format=None):
        user = request.user
        transactions = Transaction.objects.filter(Q(source_id__owner=user) | Q(target_id__owner=user))
        serializer = TransactionSerializer(transactions, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        if not SubAccount.objects.filter(sub_address=request.data["source"], owner=request.user).exists():
            return Response("Source account is not owned by current user", status=status.HTTP_403_FORBIDDEN)

        serializer = TransactionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, transaction_hash, format=None):
        transaction = self.get_object(transaction_hash)
        transaction.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class TransactionOutgoingListView(APIView):
    """
    List all outgoing transactions of logged in User.
    """

    def get(self, request, format=None):
        user = request.user
        transactions = Transaction.objects.filter(source_id__owner=user)
        serializer = TransactionSerializer(transactions, many=True)
        return Response(serializer.data)

class TransactionIncomingListView(APIView):
    """
    List all incoming transactions of logged in User.
    """

    def get(self, request, format=None):
        user = request.user
        transactions = Transaction.objects.filter(target_id__owner=user)
        serializer = TransactionSerializer(transactions, many=True)
        return Response(serializer.data)

class TransactionDetailView(APIView):
    """
    Retrieve, update or delete a transaction instance.
    """

    def get_object(self, transaction_hash):
        try:
            return Transaction.objects.get(transaction_hash=transaction_hash)
        except Transaction.DoesNotExist:
            raise Http404

    def get(self, request, transaction_hash, format=None):
        transaction = self.get_object(transaction_hash)
        transaction = TransactionSerializer(transaction)
        return Response(transaction.data)

    def put(self, request, transaction_hash, format=None):
        transaction = self.get_object(transaction_hash)
        serializer = TransactionSerializer(transaction, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, transaction_hash, format=None):
        transaction = self.get_object(transaction_hash)
        transaction.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class LoginRecordListView(APIView):
    """
    List all login_records of given user, they are created and deleted automatically by the server.
    """
    
    def get(self, request, format=None):
        login_records = LoginRecord.objects.filter(user=request.user.id)
        if len(login_records) == 0:
            return HttpResponse('No previous logins to display', status=204)
        serializer = LoginRecordSerializer(login_records, many=True)
        return Response(serializer.data)

@xframe_options_exempt
def index(request):
    return HttpResponse(render(request, "index.html"))

