from django.conf.urls.defaults import *

from piston.authentication import HttpBasicAuthentication
from piston.resource import Resource

from shoppinglist.handlers import WantHandler


auth = HttpBasicAuthentication(realm='Ok Buy Me')
want_handler = Resource(WantHandler, authentication=auth)


def pull_encoding(func):
    """
    Removes the char encoding data from the CONTENT_TYPE header and uses it to
    inform the encoding of the request data.

    NOTE: Piston won't actually be able to benefit from this encoding
    information because it reads its data directly from raw_post_data, which
    is undecoded and implicitly treated as UTF-8.
    """
    def wrapper(request, *args, **kwargs):
        ct = request.META.get('CONTENT_TYPE', '')
        if ';' in ct:
            ct, second_half = ct.split(';')
            second_half = second_half.strip()
            if second_half.startswith('charset='):
                request.encoding = second_half.replace('charset=', '')
            request.META['CONTENT_TYPE'] = ct
        return func(request, *args, **kwargs)
    return wrapper


want_handler = pull_encoding(want_handler)

urlpatterns = patterns('',
    url(r'^$', want_handler, {'emitter_format': 'json'},
            name='api-shoppinglist-want-list'),
    url(r'^want/(?P<want_id>\d+)/$', want_handler, {'emitter_format': 'json'},
            name='api-shoppinglist-want-detail'),
)
