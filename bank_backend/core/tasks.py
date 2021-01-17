from __future__ import absolute_import, unicode_literals
from celery import shared_task

from django.contrib.auth.models import User
from core.models import *

@shared_task()
def task_number_one():
    print("Hello, first periodic world!")

@shared_task()
def task_number_two():
    print(User.objects.all()[0])