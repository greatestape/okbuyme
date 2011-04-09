//
// db.js
// Override Backbone.sync to specify how to interact with the server.
//


Backbone.sync = function(method, model, options){
  switch(method) {
    case 'create':
      _.log('Backbone.sync (create)');
      break;

    case 'read':
      $.ajax({
        type: "GET",
        url: okbuyme.urls.wants,
        success: function(data, textStatus, jqXHR){
          // Call Backbone's callback from fetch(), which both parses and adds
          // the models in `data` to the collection, and calls our original
          // callback that was passed in
          options.success(data);
        },
        statusCode: {
          401: function() {
            window.location = '/my-account/'
          }
        },
        error: function(data, textStatus, jqXHR){
          options.error();
        }
      });
      break;

    case 'update':
      _.log('Backbone.sync (update)');
      break;

    case 'delete':
      $.ajax({
        type: "DELETE",
        url: model.get('resource_uri'),
        success: function(data, textStatus, jqXHR){
          options.success(data, model);
        },
        error: function(data, textStatus, jqXHR){
          options.error(data, model);
        }
      });
      break;
  }
};
