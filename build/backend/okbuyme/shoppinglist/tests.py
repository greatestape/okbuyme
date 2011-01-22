from django.test import TestCase

from shoppinglist.models import Item


class SimpleTest(TestCase):
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
