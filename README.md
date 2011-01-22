Ok Buy Me
=========

API
---

### Get List Items

- URL: `/list/`
- Method: `GET`
- Optional Params:

    - `whose` : `mine`|`ours`|`<user-id>`
    - `where` : `<location-slug>`
    - `changed-since` : `<YYYY-MM-DDTHH:MM:SS+00:00>`

- Response:


        [{
            'items': [
                {
                    'id': 1234,
                    'URL': '/list/item/1234/',
                    'name': 'Hammer',
                    'locations': [
                        {
                            'slug': 'home-depot',
                            'name': 'Home Depot'
                        },
                        {
                            'slug': 'rona'
                            'name': 'Rona'
                        }
                    ],
                    'note': "Don't spend more than $10"
                    'creation_time': '2011-01-01T12:45:00+00:00',
                    'modification_time': '2011-01-02T17:55+00:00',
                    'owner': {
                        'id': 4321,
                        'email': 'sam@pocketuniverse.ca',
                        'name': 'Sam Bull'
                    }
                },
                {
                    'id': 5678,
                    ...
                },
                ...
            ]
        }]

### Get Item

- URL: `/list/item/<id>/`
- Method: `GET`

- Response:


        [{
            'item': {
                'id': 1234,
                'URL': '/list/item/1234/',
                'name': 'Hammer',
                'locations': [
                    {
                        'slug': 'home-depot',
                        'name': 'Home Depot'
                    },
                    {
                        'slug': 'rona'
                        'name': 'Rona'
                    }
                ],
                'note': "Don't spend more than $10"
                'creation_time': '2011-01-01T12:45:00+00:00',
                'modification_time': '2011-01-02T17:55+00:00',
                'owner': {
                    'id': 4321,
                    'email': 'sam@pocketuniverse.ca',
                    'name': 'Sam Bull'
                }
            }
        }]

### Add List Item

- URL: `/list/add/`
- Method: `POST`
- POST Data

        [{
            'item': {
                'name': 'Cheerios',
                'locations': ['Loblaws', 'Metro', ...],
                'note': 'Please buy three boxes'
            }
        }]

### Edit List Item

- URL: `/list/item/<item-id>`
- Method: `PUT`
- POST Data

        [{
            'item': {
                'name': 'Cheerios',
                'locations': ['Loblaws', 'Metro', ...],
                'note': 'Please buy four boxes'
            }
        }]

### Remove List Item

- URL: `/list/item/<item-id>`
- Method: `DELETE`

### Get Locations

- URL: `/locations/`
- Method: `GET`
- Params
    - changed-since: `<YYYY-MM-DDTHH:MM:SS+00:00>`
- Response

        [{
            'locations': [
                {
                    'slug': 'rona,
                    'name': 'Rona',
                    'creation_time': '2011-01-01 12:45:00',
                    'modification_time': '2011-01-02 17:55',
                },
                {
                    'slug': 'home-depot',
                    ...
                },
                ...
            ]
        }]


### Find Friends

TODO

### Send Friend Request

TODO

### Remove Friends

TODO

### register

TODO

### change password

TODO
