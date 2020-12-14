from rest_framework import serializers
from .models import Profile, SubAccount, BankDeposit, Transaction, BitcoinTransaction
from django.contrib.auth.models import User


class ProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(read_only=True, source="user.username")
    email = serializers.CharField(read_only=True, source="user.email")
    first_name = serializers.CharField(
        read_only=True, source="user.first_name")
    last_name = serializers.CharField(read_only=True, source="user.last_name")

    def create(self, validated_data):
        user = User(
            email=validated_data['email'],
            username=validated_data['username'],
            first_name=validated_data['first_name'],        
            last_name=validated_data['last_name']
        )
        user.set_password(validated_data['password'])
        user.profile.private_key = validated_data['private_key']
        user.profile.wallet_address = validated_data['wallet_address']
        user.save()
        return user


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
