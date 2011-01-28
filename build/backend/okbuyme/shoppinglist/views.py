from django.http import HttpResponse
from django.views.generic import simple

from shoppinglist.models import Want


def list(request):
    wants = Want.objects.all()
    return simple.direct_to_template(
            request,
            'shoppinglist/want_list.html',
            extra_context={'want_list': wants},
            )
