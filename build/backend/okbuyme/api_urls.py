from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^list/', include('shoppinglist.api_urls')),
)
