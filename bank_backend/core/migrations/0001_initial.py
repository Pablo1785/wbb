# Generated by Django 3.1.4 on 2021-01-16 22:51

import datetime
from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='SubAccount',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('sub_address', models.SlugField(default='', max_length=15)),
                ('balance', models.DecimalField(blank=True, decimal_places=9, default=0, max_digits=22)),
                ('currency', models.CharField(max_length=3)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Wallet',
            fields=[
                ('owner', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='auth.user')),
                ('private_key', models.CharField(max_length=52)),
                ('wallet_address', models.CharField(max_length=34)),
            ],
        ),
        migrations.CreateModel(
            name='BankDeposit',
            fields=[
                ('account', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='core.subaccount')),
                ('interest_rate', models.DecimalField(decimal_places=3, default=0.314, max_digits=5)),
                ('start_date', models.DateTimeField(auto_now=True)),
                ('deposit_period', models.DurationField(default=datetime.timedelta(seconds=35))),
                ('capitalization_period', models.DurationField(blank=True, null=True)),
                ('last_capitalization', models.DateTimeField(blank=True, null=True)),
                ('title', models.CharField(max_length=256)),
            ],
        ),
        migrations.CreateModel(
            name='Transaction',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('amount', models.DecimalField(decimal_places=9, max_digits=22)),
                ('currency', models.CharField(max_length=3)),
                ('send_time', models.DateTimeField(auto_now=True)),
                ('confirmation_time', models.DateTimeField(blank=True, null=True)),
                ('title', models.CharField(max_length=256)),
                ('fee', models.DecimalField(blank=True, decimal_places=15, max_digits=22, null=True)),
                ('transaction_hash', models.CharField(blank=True, max_length=256, null=True)),
                ('source', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='outgoing_transactions', to='core.subaccount')),
                ('target', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='incoming_transactions', to='core.subaccount')),
            ],
        ),
        migrations.CreateModel(
            name='LoginRecord',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('action', models.CharField(max_length=64)),
                ('date', models.DateTimeField(auto_now=True)),
                ('ip_address', models.GenericIPAddressField(null=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
