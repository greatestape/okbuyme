// app-models.js


//-------------- MODEL --------------
// An Item is one thing a user wishes to have.
window.Item = Backbone.Model.extend({

  initialize: function() {
  },

  validate: function(attrs){
    console.log('Validate called');
    // TODO name required
  },

  clear: function(){
    this.destroy({
      success: function(){
        console.log('Item destroyed')
        this.view.remove();
      }
    });
  }
});


//-------------- COLLECTION --------------
// An ItemList is a group of Items, which serves as a shopping list.
window.ItemList = Backbone.Collection.extend({

  model: Item

  // TODO: need comparator

});
window.items = new ItemList;
