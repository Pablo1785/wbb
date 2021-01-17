from rest_framework import serializers
from .models import Wallet, SubAccount, BankDeposit, Transaction, LoginRecord
from django.contrib.auth.models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('username', 'email', 'first_name', 'last_name')


class WalletSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wallet
        fields = ('wallet_address',)

class FullWalletSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wallet
        fields = ('owner', 'private_key', 'wallet_address')


class SubAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubAccount
        fields = ('owner', 'balance',
                  'sub_address')


class BankDepositSerializer(serializers.ModelSerializer):
    class Meta:
        model = BankDeposit
        fields = ('account', 'interest_rate', 'start_date', 'deposit_period',
                  'capitalization_period', 'last_capitalization', 'title')


class TransactionSerializer(serializers.ModelSerializer):
    
    def validate(self, data):
        """
        Make sure transaction is possible.
        data["source"] should be SubAccount object.
        """
        # Ensure source account exist
        try:
            source_acc = SubAccount.objects.get(sub_address=data['source'])
        except SubAccount.DoesNotExist:
            raise serializers.ValidationError("Source account does not exist.")
        except KeyError:
            raise serializers.ValidationError("Source account address not provided.")

        if "target" not in data.keys():
            raise serializers.ValidationError("Target account address not provided.")

        # Ensure source is not a BankDeposit
        if hasattr(source_acc, "bankdeposit") and source_acc.bankdeposit is not None:
            raise serializers.ValidationError("Your account is locked under deposit.")
        
        # Ensure sender has enough money
        if float(data["amount"]) + 0 if "fee" not in data.keys() else float(data["fee"]) > source_acc.balance:
            raise serializers.ValidationError("Not enough funds for the transaction.")
        
        # OK
        return data
            

    class Meta:
        model = Transaction
        fields = ('source',
                  'target', 'amount',  'send_time', 'confirmation_time', 'title', 'fee', 'transaction_hash')


class LoginRecordSerializer(serializers.ModelSerializer):
    user = serializers.SerializerMethodField()

    def get_user(self, obj):
        return obj.user.username

    class Meta:
        model = LoginRecord
        fields = ('user', 'action', 'date', 'ip_address')