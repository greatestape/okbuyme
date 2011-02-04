from django.conf.urls.defaults import *

urlpatterns = patterns('shoppinglist.views',
    (r'^$', 'list', {}, 'shoppinglist-home'),
)
