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
      _.log('Backbone.sync (read)');
      $.ajax({
        type: "GET",
        beforeSend: function(req){
          req.setRequestHeader('Authorization', okbuyme.auth.token);
        },
        url: okbuyme.urls.wants,
        success: function(data, textStatus, jqXHR){
          // Call the callback from fetch(), which both adds the models in
          // `data` to the collection and calls the original callback that was
          // passed in
          options.success(data);
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
      _.log('Backbone.sync (delete)');
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
