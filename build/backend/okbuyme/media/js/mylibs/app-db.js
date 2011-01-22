Backbone.sync = function(method, model, options){
  console.log('Calling Backbone.sync...');
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
      console.log('method: delete');
      break;
  }
};
