from django.db import models
from django.utils.translation import ugettext_lazy as _


class Item(models.Model):
    """A shopping list item"""
    name = models.CharField(_('name'), max_length=255)

    class Meta:
        ordering = []
        verbose_name = _('item')
        verbose_name_plural = _('items')

    def __unicode__(self):
        return self.name

    @models.permalink
    def get_api_url(self):
        return ('api-shoppinglist-item', (), {'item_id': self.pk})
