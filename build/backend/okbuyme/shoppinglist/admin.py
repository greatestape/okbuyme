from django.contrib import admin

from shoppinglist.models import Want


class WantAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)


admin.site.register(Want, WantAdmin)
