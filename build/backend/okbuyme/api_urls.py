from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^wants/', include('shoppinglist.api_urls')),
)
