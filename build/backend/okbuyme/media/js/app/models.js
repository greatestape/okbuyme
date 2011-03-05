// app-models.js


//-------------- MODEL --------------
// A Want is one thing a user wishes to have.
window.Want = Backbone.Model.extend({

  initialize: function() {
  },

  validate: function(attrs){
    console.log('Validate called');
  },

  clear: function(){
    this.destroy({
      error: function(model, data){
        alert('An error occurred deleting your item.');
      },
      success: function(model, data){
        model.view.remove();
      }
    });
  }
});


//-------------- COLLECTION --------------
// An WantList is a group of Wants, which serves as a shopping list.
window.WantList = Backbone.Collection.extend({

  model: Want

});
window.wants = new WantList();
