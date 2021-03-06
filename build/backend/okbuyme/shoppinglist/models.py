import datetime

from django.db import models
from django.http import HttpRequest
from django.utils.translation import ugettext_lazy as _

import dateutil
from piston.emitters import JSONEmitter
from piston.handler import typemapper
import pytz


class Want(models.Model):
    """Something somebody wants"""
    owner = models.ForeignKey('auth.User')
    name = models.CharField(_('name'), max_length=255)
    notes = models.TextField(_('notes'), blank=True)
    utc_creation_time = models.DateTimeField(blank=True, null=True)
    utc_last_updated_time = models.DateTimeField(blank=True, null=True)

    class Meta:
        verbose_name = _('want')
        verbose_name_plural = _('wants')

    def __unicode__(self):
        return self.name

    def _get_creation_time(self):
        return _timezoneify(self.utc_creation_time)

    def _set_creation_time(self, dt):
        self.utc_creation_time = _detimezoneify(dt)

    creation_time = property(_get_creation_time, _set_creation_time)

    def _get_last_updated_time(self):
        return _timezoneify(self.utc_last_updated_time)

    def _set_last_updated_time(self, dt):
        self.utc_last_updated_time = _detimezoneify(dt)

    last_updated_time = property(_get_last_updated_time, _set_last_updated_time)

    def save(self, *args, **kwargs):
        if not self.pk and not self.creation_time:
            self.creation_time = datetime.datetime.now(pytz.utc)
        self.last_updated_time = datetime.datetime.now(pytz.utc)
        super(Want, self).save(*args, **kwargs)

    @models.permalink
    def get_api_url(self):
        return ('api-shoppinglist-want-detail', (), {'want_id': self.pk})

    def get_json(self):
        from shoppinglist.handlers import WantHandler
        return JSONEmitter(self, typemapper, WantHandler,
                WantHandler.fields, False).render(HttpRequest())


def _timezoneify(dt, tz=pytz.utc):
    if dt is not None:
        return dt.replace(tzinfo=tz)
    else:
        return dt


def _detimezoneify(dt, tz=pytz.utc):
    if dt is not None:
        return dt.astimezone(tz).replace(tzinfo=None)
    else:
        return dt
