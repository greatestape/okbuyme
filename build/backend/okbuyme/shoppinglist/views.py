from django.http import HttpResponse
from django.views.generic import simple

from shoppinglist.models import Item


def list(request):
    items = Item.objects.all()
    return simple.direct_to_template(
            request,
            'shoppinglist/item_list.html',
            extra_context={'item_list': items},
            )
