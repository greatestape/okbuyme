from piston.handler import BaseHandler

from shoppinglist.models import Want


class WantHandler(BaseHandler):
    allowed_methods = ('GET',)
    model = Want
    fields = ('id', 'name', 'notes', 'creation_time', 'last_updated_time')

    @classmethod
    def creation_time(self, instance):
        return instance.creation_time.isoformat('T')

    @classmethod
    def last_updated_time(self, instance):
        return instance.last_updated_time.isoformat('T')

    def read(self, request, want_id=None):
        """
        Returns a single post if `want_id` is given,
        otherwise a subset.

        """
        base = Want.objects

        if want_id:
            return base.get(pk=want_id)
        else:
            return base.all() # Or base.filter(...)
