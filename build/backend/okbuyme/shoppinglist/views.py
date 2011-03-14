from django.shortcuts import redirect
from django.views.generic import simple

from shoppinglist.models import Want
from shoppinglist.forms import WantForm


def list(request):
    form = WantForm()
    if request.user.is_authenticated():
        wants = Want.objects.filter(owner=request.user)
    else:
        wants = Want.objects.none()
    return simple.direct_to_template(
            request,
            'shoppinglist/want_list.html',
            extra_context={
                'want_list': wants,
                'form': form},
            )
