// app-models.js


//-------------- MODEL --------------
// A Want is one thing a user wishes to have.
window.Want = Backbone.Model.extend({

  initialize: function() {
  },

  validate: function(attrs){
    console.log('Validate called');
    // TODO name required
  },

  clear: function(){
    this.destroy({
      success: function(){
        console.log('Want destroyed');
        this.view.remove();
      }
    });
  }
});


//-------------- COLLECTION --------------
// An WantList is a group of Wants, which serves as a shopping list.
window.WantList = Backbone.Collection.extend({

  model: Want

  // TODO: need comparator

});
window.wants = new WantList();
