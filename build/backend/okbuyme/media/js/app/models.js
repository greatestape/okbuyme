//
// models.js
// Define the Backbone Models and Collections used in the app.
//


//
// A Want is one thing a user wishes to have.
//
Want = Backbone.Model.extend({

  initialize: function() {
  },

  validate: function(attrs) {
    var errors = {};
    if (attrs.name === "") {
      errors.name = "You must provide a name for this item.";
    }
    if (!_.isEmpty(errors)) {
      return errors;
    }
  },

  clear: function(){
    this.destroy({
      success: function(model, data){
        model.view.remove();
      },
      error: function(model, data){
        alert('An error occurred deleting your item.');
      }
    });
  },

  doSave: function(view){
    _.log('doSave');
    this.save(this.attributes, {
      success: function(model, data){
        _.log("Save callback!");
        //model.view.handleSave();
      },
      error: function(model, errorObj){
        view.handleError(model, errorObj);
      }
    });
  }
});


//
// An WantList is a group of Wants, which serves as a shopping list.
//
WantList = Backbone.Collection.extend({

  model: Want

});

// expose the collection of wants by adding it to the app's namespace
okbuyme.app.wants = new WantList();
