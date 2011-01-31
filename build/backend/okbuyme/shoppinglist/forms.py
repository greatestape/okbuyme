from django import forms

from shoppinglist.models import Want


class WantForm(forms.ModelForm):
    class Meta:
        model = Want
        fields = ('name', 'notes')
