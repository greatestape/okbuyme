from django.shortcuts import redirect
from django.views.generic import simple

from shoppinglist.models import Want
from shoppinglist.forms import WantForm


def list(request):
    if request.user.is_authenticated():
        form = WantForm()
        wants = Want.objects.filter(owner=request.user)
        return simple.direct_to_template(
                request,
                'shoppinglist/want_list.html',
                extra_context={
                    'want_list': wants,
                    'form': form},
                )
    else:
        return simple.direct_to_template(
                request,
                'home.html')
