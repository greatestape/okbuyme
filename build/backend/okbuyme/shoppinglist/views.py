from django.shortcuts import redirect
from django.views.generic import simple

from shoppinglist.models import Want
from shoppinglist.forms import WantForm


def list(request):
    wants = Want.objects.all()
    return simple.direct_to_template(
            request,
            'shoppinglist/want_list.html',
            extra_context={'want_list': wants},
            )


def add(request):
    if request.method == 'POST':
        form = WantForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('shoppinglist-home')
    else:
        form = WantForm()
    return simple.direct_to_template(
            request,
            'shoppinglist/want_add.html',
            extra_context={'form': form}
            )
