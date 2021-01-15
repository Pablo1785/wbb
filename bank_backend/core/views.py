from .serializers import UserSerializer, SubAccountSerializer, BankDepositSerializer, TransactionSerializer
from .models import SubAccount, BankDeposit, Transaction
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.http import Http404
from django.contrib.auth.models import User

# Create your views here.


class UserListView(APIView):
    """
    List all users and profiles, or create a new user with profile.
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

    def get_object(self, pk):
        try:
            return User.objects.get(pk=pk)
        except User.DoesNotExist:
            raise Http404

    def get(self, request, format=None):
        user = self.get_object(request)
        user = UserSerializer(user)
        return Response(user.data)

    def put(self, request, format=None):
        user = self.get_object(request)
        serializer = UserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, format=None):
        user = self.get_object(request)
        user.delete()
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
        request.data['owner'] = request.user.id
        serializer = SubAccountSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, format=None):
        subaccount = self.get_object(request)
        subaccount.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class SubAccountDetailView(APIView):
    """
    Retrieve, update or delete a subaccount instance.
    """

    def get_object(self, request):
        try:
            return SubAccount.objects.get(sub_address=request["sub_address"])
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
        try:
            request.data["account"] = SubAccount.objects.get(sub_address=request.data["account"]).id
        except KeyError:
            return Response("Missing account field", status=status.HTTP_400_BAD_REQUEST)

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
        try:
            request.data["source"] = SubAccount.objects.get(sub_address=request.data["source"]).id
            request.data["target"] = SubAccount.objects.get(sub_address=request.data["target"]).id
        except KeyError:
            return Response("Missing source and/or target field", status=status.HTTP_400_BAD_REQUEST)

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

