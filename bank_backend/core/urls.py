from core import views
from django.conf.urls import url


urlpatterns = [
    url(r'^user/$', views.UserListView.as_view()),
    url(r'^user/(?P<pk>[0-9]+)/$', views.UserDetailView.as_view()),
    url(r'^subacc/$', views.SubAccountListView.as_view()),
    url(r'^subacc/(?P<pk>[0-9]+)/$', views.SubAccountDetailView.as_view()),
    url(r'^deposit/$', views.BankDepositListView.as_view()),
    url(r'^deposit/(?P<pk>[0-9]+)/$', views.BankDepositDetailView.as_view()),
    url(r'^trans/$', views.TransactionListView.as_view()),
    url(r'^trans/(?P<pk>[0-9]+)/$', views.TransactionDetailView.as_view()),
]