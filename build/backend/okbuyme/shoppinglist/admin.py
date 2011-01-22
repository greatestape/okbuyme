from django.contrib import admin

from shoppinglist.models import Item


class ItemAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)


admin.site.register(Item, ItemAdmin)
