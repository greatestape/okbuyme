from django.conf.urls.defaults import *

from piston.resource import Resource

from shoppinglist.handlers import ItemHandler


item_handler = Resource(ItemHandler)


urlpatterns = patterns('',
    url(r'^$', item_handler, {'emitter_format': 'json'},
            name='api-shoppinglist-item-list'),
)
