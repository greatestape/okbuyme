from django.core.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from piston.handler import BaseHandler
from piston.utils import rc, require_mime

from shoppinglist.models import Want


class WantHandler(BaseHandler):
    allowed_methods = ('GET', 'PUT', 'POST', 'DELETE')
    model = Want
    fields = ('id', 'name', 'notes', 'creation_time', 'last_updated_time')

    @classmethod
    def creation_time(self, instance):
        return instance.creation_time.isoformat('T')

    @classmethod
    def last_updated_time(self, instance):
        return instance.last_updated_time.isoformat('T')

    @require_mime('json')
    def create(self, request):
        return _fill_and_validate(
                Want(owner=request.user), request.data, rc.CREATED)

    def read(self, request, want_id=None):
        """
        Returns a single post if `want_id` is given,
        otherwise a subset.

        """
        base = Want.objects

        if want_id:
            return base.get(pk=want_id)
        else:
            return base.filter(owner=request.user)

    @require_mime('json')
    def update(self, request, want_id):
        want = get_object_or_404(Want, owner=request.user, id=want_id)
        return _fill_and_validate(want, request.data, rc.ALL_OK)

    def delete(self, request, want_id):
        get_object_or_404(Want, owner=request.user, id=want_id).delete()
        return rc.DELETED


def _clean_data(data, valid_fields):
    unknown_fields = set(data.keys()) - set(valid_fields)
    if len(unknown_fields) > 0:
        raise ValidationError("Received unknown fields: %s" % ', '.join(unknown_fields))
    return data


def _fill_and_validate(want, data, success_response):
    try:
        data = _clean_data(data, ('name', 'notes'))
        for field, value in data.items():
            setattr(want, field, value)
        want.save()
    except ValidationError, e:
        resp = rc.BAD_REQUEST
        resp.write(unicode(e))
    else:
        resp = success_response
    return resp
