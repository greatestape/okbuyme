from django.core.urlresolvers import reverse
from django.test import TestCase
from django.utils import simplejson

from shoppinglist.models import Item


class WebTests(TestCase):
    def test_homepage_loads(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)

    def test_items_appear_on_home_page(self):
        item = Item.objects.create(name='Test Item')
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        item_list = response.context['item_list']
        self.assertIn(item, item_list)
        self.assertContains(response, 'Test Item')

class APITests(TestCase):
    def setUp(self):
        self.item = Item.objects.create(name='Test Item')

    def test_list_items(self):
        response = self.client.get(reverse('api-shoppinglist-item-list'))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Content-Type'], 'application/json; charset=utf-8')
        item_list = simplejson.loads(response.content)
        self.assertEqual(item_list[0]['name'], self.item.name)
        self.assertEqual(item_list[0]['id'], self.item.pk)
