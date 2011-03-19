from django.conf.urls.defaults import *
from django.contrib import admin

from utils.views import serve_js_constants

admin.autodiscover()

urlpatterns = patterns('',
    (r'^admin/doc/', include('django.contrib.admindocs.urls')),
    (r'^admin/', include(admin.site.urls)),
    (r'^api/', include('api_urls')),
    (r'^media/js/app/constants.js$', serve_js_constants, {}, 'js-constants'),
    (r'^', include('shoppinglist.urls')),
)
