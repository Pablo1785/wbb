# Generated by Django 3.1.4 on 2020-12-10 18:29

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='SubAccount',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('balance', models.DecimalField(decimal_places=9, max_digits=22)),
                ('currency', models.CharField(max_length=3)),
                ('sub_address', models.CharField(max_length=32)),
                ('deposit_status', models.BooleanField(default=False)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Transaction',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('amount', models.DecimalField(decimal_places=9, max_digits=22)),
                ('currency', models.CharField(max_length=3)),
                ('source_address', models.CharField(max_length=32)),
                ('target_address', models.CharField(max_length=32)),
                ('timestamp', models.DateTimeField()),
                ('send_time', models.DateTimeField()),
                ('confirmation_time', models.DateTimeField()),
                ('title', models.CharField(max_length=256)),
                ('account', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='core.subaccount')),
            ],
        ),
        migrations.CreateModel(
            name='BankDeposit',
            fields=[
                ('account', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='core.subaccount')),
                ('interest_rate', models.DecimalField(decimal_places=3, max_digits=5)),
                ('start_date', models.DateTimeField()),
                ('deposit_period', models.DurationField()),
                ('capitalization_period', models.DurationField()),
                ('last_capitalization', models.DateTimeField()),
                ('title', models.CharField(max_length=256)),
            ],
        ),
        migrations.CreateModel(
            name='BitcoinTransaction',
            fields=[
                ('account', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='core.transaction')),
                ('source_address', models.CharField(max_length=34)),
                ('target_address', models.CharField(max_length=34)),
                ('amount', models.DecimalField(decimal_places=9, max_digits=22)),
                ('miner_fee', models.DecimalField(decimal_places=9, max_digits=22)),
            ],
        ),
        migrations.CreateModel(
            name='Profile',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('private_key', models.CharField(max_length=52)),
                ('wallet_address', models.CharField(max_length=34)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
