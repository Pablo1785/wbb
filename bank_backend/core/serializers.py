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
        fields = ('owner', 'balance', 'currency',
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
        data["source"] and data["target"] should be SubAccount objects.
        """
        # Ensure source and target accounts exist
        try:
            source_acc = data["source"]
            target_acc = data["target"]
        except SubAccount.DoesNotExist:
            raise serializers.ValidationError("Account does not exist.")
        except KeyError:
            raise serializers.ValidationError("Account address not provided.")

        # Ensure source is not a BankDeposit
        if hasattr(self.source, "bankdeposit") and self.source.bankdeposit is not None:
            raise serializers.ValidationError("Your account is locked under deposit.")
        
        # Ensure both accounts use the same currency and Transaction has the correct currency
        if not (source_acc.currency == target_acc.currency):
            raise serializers.ValidationError("Your account uses a different currency than the receiving account.")

        # Ensure sender has enough money
        if float(data["amount"]) + 0 if "fee" not in data.keys() else float(data["fee"]) > source_acc.balance:
            raise serializers.ValidationError("Not enough funds for the transaction.")
        
        # OK
        return data
            

    class Meta:
        model = Transaction
        fields = ('source',
                  'target', 'amount', 'currency',  'send_time', 'confirmation_time', 'title', 'fee', 'transaction_hash')


class LoginRecordSerializer(serializers.ModelSerializer):
    user = serializers.SerializerMethodField()

    def get_user(self, obj):
        return obj.user.username

    class Meta:
        model = LoginRecord
        fields = ('user', 'action', 'date', 'ip_address')