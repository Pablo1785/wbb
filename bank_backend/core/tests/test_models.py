from django.test import TestCase
from core.models import Profile, SubAccount, BankDeposit, Transaction, BitcoinTransaction
from django.contrib.auth.models import User


class ModelsTest(TestCase):
    def create_user(self, username="testuser", private_key="testkey", wallet_address="testaddress"):
        user = User.objects.create_user(username)
        user.save()
        user.profile.private_key = private_key
        user.profile.wallet_address = wallet_address
        user.save()
        return user

    def test_proflie_creation(self):
        user = self.create_user()
        profile = Profile.objects.get(pk=user.id)

        self.assertTrue(isinstance(user, User))
        self.assertTrue(isinstance(profile, Profile))
        self.assertEqual(profile.owner, user)
        self.assertEqual(profile.private_key, "testkey")
        self.assertEqual(profile.wallet_address, "testaddress")

    def create_subaccount(self, owner, currency="BTC", sub_address="testaddress"):
        return SubAccount.objects.create(owner=owner, currency=currency, sub_address=sub_address)

    def test_subaccount_creation(self):
        user = self.create_user()
        subaccount = self.create_subaccount(user)

        self.assertTrue(isinstance(subaccount, SubAccount))
        self.assertEqual(subaccount.owner, user)
        self.assertEqual(subaccount.balance, 0)
        self.assertEqual(subaccount.currency, "BTC")
        self.assertEqual(subaccount.sub_address, "testaddress")
        self.assertEqual(subaccount.deposit_status, False)

