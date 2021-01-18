from __future__ import absolute_import, unicode_literals
from celery import shared_task

from django.contrib.auth.models import User
from core.models import *

from datetime import datetime

class TxNotConfirmedException(Exception):
  pass

@shared_task(bind=True, autoretry_for=(TxNotConfirmedException,), retry_kwargs={'max_retries': 7, 'countdown': 5})
def check_transaction_confirmed(self, transaction):
  if not True:  # if condition not met
    raise TxNotConfirmedException()  # task failed - raise exception

"""
Uruchomienie taska:

from core.tasks import *

task_func.delay(args=(transaction,))
"""
