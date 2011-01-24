# encoding: utf-8
import datetime

from django.db import models

import pytz
from south.db import db
from south.v2 import DataMigration

from shoppinglist.models import _detimezoneify


class Migration(DataMigration):

    def forwards(self, orm):
        # Choose the original bitworker's day as the default creation date
        localtz = pytz.timezone('America/Toronto')
        creation_time = datetime.datetime(2011,1,22,12,0,0, tzinfo=localtz)
        for item in orm['shoppinglist.item'].objects.all():
            item.utc_creation_time = _detimezoneify(creation_time)
            item.utc_last_updated_time = _detimezoneify(datetime.datetime.now(localtz))
            item.save()


    def backwards(self, orm):
        pass


    models = {
        'shoppinglist.item': {
            'Meta': {'object_name': 'Item'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'notes': ('django.db.models.fields.TextField', [], {'blank': 'True'}),
            'utc_creation_time': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'utc_last_updated_time': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'})
        }
    }

    complete_apps = ['shoppinglist']
