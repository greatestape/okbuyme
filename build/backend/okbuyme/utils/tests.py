from django.core.urlresolvers import reverse
from django.test import TestCase


class UtilsTests(TestCase):
    def test_js_constants_loads(self):
        response = self.client.get(reverse('js-constants'))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'constants.js')
