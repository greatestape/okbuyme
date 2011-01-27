from django.conf.urls.defaults import *

from piston.resource import Resource

from shoppinglist.handlers import WantHandler


want_handler = Resource(WantHandler)


urlpatterns = patterns('',
    url(r'^$', want_handler, {'emitter_format': 'json'},
            name='api-shoppinglist-want-list'),
    url(r'^want/(?P<want_id>\d+)/$', want_handler, {'emitter_format': 'json'},
            name='api-shoppinglist-want-detail'),
)
