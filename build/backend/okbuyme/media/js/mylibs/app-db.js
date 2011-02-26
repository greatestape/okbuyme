Backbone.sync = function(method, model, options){
  switch(method) {
    case 'create':
      console.log('method: create');
      break;

    case 'read':
      console.log('method: read');
      break;

    case 'update':
      console.log('method: update');
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
  }
};
