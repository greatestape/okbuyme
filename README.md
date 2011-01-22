Ok Buy Me
=========

API
---

### Get List Items

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

### Add List Item

- POST Data

        [{
            'item': {
                'name': 'Cheerios',
                'locations': ['Loblaws', 'Metro', ...],
                'note': 'Please buy three boxes'
            }
        }]


### Get Locations

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
