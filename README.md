Ok Buy Me
=========

API
---

### Get List Items

- URL: `/api/wants/`
- Method: `GET`
- Optional Params:

    - `whose` : `mine`|`ours`|`<user-id>` (TODO)
    - `where` : `<location-slug>` (TODO)
    - `changed-since` : `<YYYY-MM-DDTHH:MM:SS+00:00>` (TODO)

- Response:


        [
            {
                'id': 1234,
                'resource_uri': '/api/wants/want/1234/',
                'name': 'Hammer',
                'notes': "Don't spend more than $10",
                'creation_time': '2011-01-01T12:45:00+00:00',
                'last_updated_time': '2011-01-02T17:55+00:00',
            },
            {
                'id': 5678,
                ...
            },
        ]

### Get Item

- URL: `/api/wants/want/<id>/`
- Method: `GET`

- Response:


        {
            'id': 1234,
            'resource_uri': '/api/wants/want/1234/',
            'name': 'Hammer',
            'notes': "Don't spend more than $10",
            'creation_time': '2011-01-01T12:45:00+00:00',
            'last_updated_time': '2011-01-02T17:55+00:00',
        }

### Add List Item

- URL: `/api/wants/`
- Method: `POST`
- POST Data

        {
            'name': 'Cheerios',
            'notes': 'Please buy three boxes'
        }

### Edit List Item

- URL: `/api/wants/want/<item-id>/`
- Method: `PUT`
- POST Data

        {
            'name': 'Cheerios',
            'notes': 'Please buy four boxes'
        }

### Remove List Item

- URL: `/api/wants/want/<item-id>/`
- Method: `DELETE`

### Get Locations (TODO)

- URL: `/api/locations/`
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
