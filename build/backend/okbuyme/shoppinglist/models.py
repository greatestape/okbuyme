from django.db import models
from django.utils.translation import ugettext_lazy as _


class Item(models.Model):
    """A shopping list item"""
    name = models.CharField(max_length=255)

    class Meta:
        ordering = []
        verbose_name = _('item')
        verbose_name_plural = _('items')

    def __unicode__(self):
        return self.name
