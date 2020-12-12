from rest_framework import serializers
from .models import Profile, SubAccount, BankDeposit, Transaction, BitcoinTransaction


class ProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(read_only=True, source="user.username")
    email = serializers.CharField(read_only=True, source="user.email")
    first_name = serializers.CharField(
        read_only=True, source="user.first_name")
    last_name = serializers.CharField(read_only=True, source="user.last_name")

    class Meta:
        model = Profile
        fields = ('user', 'username', 'email', 'first_name', 'last_name',
                  'private_key', 'wallet_address')


class SubAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubAccount
        fields = ('id', 'owner', 'balance', 'currency',
                  'sub_address', 'deposit_status')


class BankDepositSerializer(serializers.ModelSerializer):
    class Meta:
        model = BankDeposit
        fields = ('account', 'interest_rate', 'start_date', 'deposit_period',
                  'capitalization_period', 'last_capitalization', 'title')


class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = ('account', 'amount', 'currency', 'source_address',
                  'target_address', 'timestamp', 'send_time', 'confirmation_time', 'title')


class BitcoinTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = BitcoinTransaction
        fields = ('account', 'source_address',
                  'target_address', 'amount', 'miner_fee')
