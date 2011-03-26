import os

from django.conf import settings
from django.conf.urls.defaults import *

from urls import urlpatterns


urlpatterns += patterns('',
    (r'^media/(.*)$', 'django.views.static.serve', {'document_root':
        settings.MEDIA_ROOT}),
    (r'^js-tests/$', 'django.views.generic.simple.direct_to_template', {
        'template': 'javascript/SpecRunner.html'
    }),
    (r'^js-tests/fixtures/(.*)$', 'django.views.static.serve', {
        'document_root': os.path.join(settings.MEDIA_ROOT, 'js/tests/fixtures/')}
    ),
)
