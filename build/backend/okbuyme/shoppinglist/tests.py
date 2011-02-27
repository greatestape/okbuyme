# Encoding: UTF-8
import base64
import datetime

from django.core.urlresolvers import reverse
from django.test import TestCase
from django.utils import simplejson

import pytz

from shoppinglist.models import Want


class WebTests(TestCase):
    def test_homepage_loads(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)

    def test_wants_appear_on_home_page(self):
        want = Want.objects.create(name='Test Want')
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        want_list = response.context['want_list']
        self.assertIn(want, want_list)
        self.assertContains(response, 'Test Want')

    def test_form_appears_on_home_page(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'form')
        self.assertFalse(response.context['form'].is_bound)


class ModelTests(TestCase):
    def test_creation_time_is_set(self):
        want = Want.objects.create(name='Test Want')
        self.assertEqual(type(want.creation_time), datetime.datetime)

    def test_creation_time_is_set_once(self):
        original_creation_time = datetime.datetime(2010,1,1,15,30,10, tzinfo=pytz.utc)
        want = Want.objects.create(name='Test Want',
                creation_time=original_creation_time)
        want.save()
        want = Want.objects.get(pk=want.pk)
        self.assertEqual(want.creation_time, original_creation_time)

    def test_last_updated_is_set(self):
        want = Want.objects.create(name='Test Want')
        self.assertEqual(type(want.last_updated_time), datetime.datetime)

    def test_last_updated_is_always_updated(self):
        want = Want.objects.create(name='Test Want')
        want.save()
        original_last_updated_time = want.last_updated_time
        want.name = 'New Name'
        want.save()
        want = Want.objects.get(pk=want.pk)
        self.assertNotEqual(want.last_updated_time, original_last_updated_time)


class APITests(TestCase):
    def setUp(self):
        self.creation_time = datetime.datetime(2010, 2, 3, 4, 5, 6, tzinfo=pytz.utc)
        self.want = Want.objects.create(
                name='Test Want',
                notes="Don't forget to foobar",
                creation_time=self.creation_time)

    def test_want_list(self):
        response = self.client.get(reverse('api-shoppinglist-want-list'))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Content-Type'], 'application/json; charset=utf-8')
        want_list = simplejson.loads(response.content)
        self.assertEqual(want_list[0]['name'], self.want.name)
        self.assertEqual(want_list[0]['id'], self.want.pk)
        self.assertEqual(want_list[0]['resource_uri'], self.want.get_api_url())
        self.assertEqual(want_list[0]['notes'], self.want.notes)
        self.assertEqual(want_list[0]['creation_time'],
                self.creation_time.isoformat('T'))
        self.assertEqual(want_list[0]['last_updated_time'],
                self.want.last_updated_time.isoformat('T'))

    def test_want_detail(self):
        response = self.client.get(reverse('api-shoppinglist-want-detail',
                kwargs={'want_id': self.want.id}))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Content-Type'], 'application/json; charset=utf-8')
        want = simplejson.loads(response.content)
        self.assertEqual(want['name'], self.want.name)
        self.assertEqual(want['id'], self.want.pk)
        self.assertEqual(want['resource_uri'], self.want.get_api_url())
        self.assertEqual(want['notes'], self.want.notes)
        self.assertEqual(want['creation_time'],
                self.creation_time.isoformat('T'))
        self.assertEqual(want['last_updated_time'],
                self.want.last_updated_time.isoformat('T'))

    def test_model_can_generate_json(self):
        response = self.client.get(reverse('api-shoppinglist-want-detail',
                kwargs={'want_id': self.want.id}))
        self.assertEqual(self.want.get_json(), response.content)

    def test_want_update(self):
        response = self.client.put(reverse('api-shoppinglist-want-detail',
                kwargs={'want_id': self.want.id}),
                data=simplejson.dumps({'notes': 'A new note'}),
                content_type='application/json')
        self.assertEqual(response.status_code, 200,
                "Response wasn't 200. It was %s: %s" % (response.status_code, response.content))
        want = Want.objects.get(pk=self.want.pk)
        # Test notes has been updated
        self.assertEqual(want.notes, 'A new note')
        # Test name hasn't been updated
        self.assertEqual(want.name, 'Test Want')

    def test_want_create(self):
        response = self.client.post(reverse('api-shoppinglist-want-list'),
                data=simplejson.dumps({'name': 'A new want'}),
                content_type='application/json')
        self.assertEqual(response.status_code, 201,
                "Response wasn't 201. It was %s: %s" % (response.status_code, response.content))
        new_want = Want.objects.latest('id')
        self.assertNotEqual(new_want, self.want)
        self.assertEqual(new_want.name, 'A new want')

    def test_want_delete(self):
        response = self.client.delete(reverse('api-shoppinglist-want-detail',
                kwargs={'want_id': self.want.id}))
        self.assertEqual(response.status_code, 204,
                "Response wasn't 204. It was %s: %s" % (response.status_code, response.content))
        self.assertEqual(Want.objects.filter(pk=self.want.pk).count(), 0)

    def test_content_type_encoding_handling(self):
        response = self.client.post(reverse('api-shoppinglist-want-list'),
                data='{"name": "Acme SuperAnvil™"}',
                content_type='application/json; charset=UTF-8')
        self.assertEqual(response.status_code, 201,
                "Response wasn't 201. It was %s: %s" % (response.status_code, response.content))
        new_want = Want.objects.latest('id')
        self.assertNotEqual(new_want, self.want)
        self.assertEqual(new_want.name, u'Acme SuperAnvil™')
