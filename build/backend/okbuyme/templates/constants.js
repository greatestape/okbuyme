//
// constants.js
// This file does two things:
// 1. It's rendered by Django, which allows dynamic variables to be made available to JavaScript;
// 2. The namespace and empty objects for the app are established.
//


var okbuyme = {
    // HTTP auth header string to be used in AJAX calls to the API. 
    // TODO This is hardcoded now, but it needs to be computed in the backend and
    // made available in the Django context here somehow.
    auth: {
        token: 'Basic ZGxpbWViOmQ=' // "dlimeb/d"
        //token: 'Basic am9lOmo='     // "joe/j"
    },

    // URLs for the API
    urls: {
        wants: '{% url api-shoppinglist-want-list %}'
    },

    // Placeholder object where the app components will go
    app: {}
};
