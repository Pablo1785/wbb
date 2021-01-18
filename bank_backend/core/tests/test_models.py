from django.test import TestCase
from core.models import Wallet, SubAccount, BankDeposit, Transaction
from django.contrib.auth.models import User


class ModelsTest(TestCase):
    def create_user(self, uname):
        return User.objects.create(username=uname)

    def create_subaccount(self, owner):
        return SubAccount.objects.create(owner=owner)

    def test_user_creation(self):
        user = self.create_user('test')

        self.assertTrue(isinstance(user, User))
        self.assertEqual(user.username, 'test')

    def test_wallet_creation(self):
        user = self.create_user('wallet_test')
        wallet = Wallet.objects.create(owner=user, private_key='test_key', wallet_address='test_address')

        self.assertTrue(isinstance(wallet, Wallet))
        self.assertEqual(wallet.owner, user)
        self.assertEqual(wallet.private_key, 'test_key')
        self.assertEqual(wallet.wallet_address, 'test_address')


    def test_subaccount_creation(self):
        user = self.create_user('subaccount_test')
        subaccount = self.create_subaccount(user)

        self.assertTrue(isinstance(subaccount, SubAccount))
        self.assertEqual(subaccount.owner, user)
        self.assertEqual(subaccount.balance, 0)

