Ok Buy Me
=========

API
---

### Get List Items

- URL: `/api/list/`
- Method: `GET`
- Optional Params:

    - `whose` : `mine`|`ours`|`<user-id>`
    - `where` : `<location-slug>`
    - `changed-since` : `<YYYY-MM-DDTHH:MM:SS+00:00>`

- Response:


        [
            {
                'id': 1234,
                'resource_uri': '/api/list/1234/',
                'name': 'Hammer',
                'note': "Don't spend more than $10",
                'creation_time': '2011-01-01T12:45:00+00:00',
                'last_updated_time': '2011-01-02T17:55+00:00',
            },
            {
                'id': 5678,
                ...
            },
        ]

### Get Item

- URL: `/api/list/<id>/`
- Method: `GET`

- Response:


        {
            'id': 1234,
            'resource_uri': '/api/list/1234/',
            'name': 'Hammer',
            'note': "Don't spend more than $10",
            'creation_time': '2011-01-01T12:45:00+00:00',
            'last_updated_time': '2011-01-02T17:55+00:00',
        }

### Add List Item

- URL: `/api/list/add/`
- Method: `POST`
- POST Data

        {
            'item': {
                'name': 'Cheerios',
                'note': 'Please buy three boxes'
            }
        }

### Edit List Item

- URL: `/api/list/<item-id>/`
- Method: `PUT`
- POST Data

        {
            'item': {
                'name': 'Cheerios',
                'note': 'Please buy four boxes'
            }
        }

### Remove List Item

- URL: `/list/<item-id>/`
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
