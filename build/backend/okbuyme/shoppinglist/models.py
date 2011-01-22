import datetime

from django.db import models
from django.utils.translation import ugettext_lazy as _

import dateutil
import pytz


class Item(models.Model):
    """A shopping list item"""
    name = models.CharField(_('name'), max_length=255)
    notes = models.TextField(_('notes'), blank=True)
    creation_time = models.DateTimeField(blank=True, null=True)

    class Meta:
        ordering = []
        verbose_name = _('item')
        verbose_name_plural = _('items')

    def __unicode__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.pk and not self.creation_time:
            self.creation_time = datetime.datetime.now(pytz.utc)
        super(Item, self).save(*args, **kwargs)

    @models.permalink
    def get_api_url(self):
        return ('api-shoppinglist-item', (), {'item_id': self.pk})
