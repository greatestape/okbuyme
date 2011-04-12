//
// db.js
// Override Backbone.sync to specify how to interact with the server.
//


Backbone.sync = function(method, model, options){
  switch(method) {
    case 'create':
      $.ajax({
        type: "POST",
        url: okbuyme.urls.wants,
        data: model.attributes,
        success: function(data, textStatus, jqXHR){
          options.success(data, model);
        },
        statusCode: {
          401: function() {
            window.location = '/my-account/' // TODO add url to constants.js (when it exists)
          }
        },
        error: function(data, textStatus, jqXHR){
          options.error(data, model);
        }
      });
      break;

    case 'read':
      $.ajax({
        type: "GET",
        url: okbuyme.urls.wants,
        success: function(data, textStatus, jqXHR){
          options.success(data, model);
        },
        statusCode: {
          401: function() {
            window.location = '/my-account/'
          }
        },
        error: function(data, textStatus, jqXHR){
          options.error(data, model);
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
