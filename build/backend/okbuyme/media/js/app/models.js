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
    _.log("Validating...");
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

  doSave: function(){
    _.log('doSave');
    this.save(this.attributes, {
      success: function(model, data){ // TODO will not work until model is returned from server in AJAX call in db.js
        _.log("Save callback!");
        //model.view.handleSave();
      },
      error: function(model, data){ // TODO this callback is called when handling form validation errors
        _.log("Error callback.");
        //model.view.handleError();
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
