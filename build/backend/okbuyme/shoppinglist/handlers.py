from piston.handler import BaseHandler

from shoppinglist.models import Item


class ItemHandler(BaseHandler):
    allowed_methods = ('GET',)
    model = Item
    fields = ('id', 'name', 'notes')

    def read(self, request, item_id=None):
        """
        Returns a single post if `item_id` is given,
        otherwise a subset.

        """
        base = Item.objects

        if item_id:
            return base.get(pk=item_id)
        else:
            return base.all() # Or base.filter(...)
