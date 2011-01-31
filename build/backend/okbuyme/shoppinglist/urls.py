from django.conf.urls.defaults import *

urlpatterns = patterns('shoppinglist.views',
    (r'^$', 'list', {}, 'shoppinglist-home'),
    (r'^add/$', 'add', {}, 'shoppinglist-add'),
)
