// app-views.js


//-------------- VIEWS --------------

// View for one Want (ie one entry in the wants list).
window.WantView = Backbone.View.extend({

  tagName: "li",

  template: _.template($('#WantTemplate').html()),

  initialize: function() {
    _.bindAll(this, "render");
    this.model.view = this;
  },

  render: function() {
    model_data = this.model.toJSON();
    var html = $(this.el).html(this.template(model_data));
    return this;
  },

  events: {
    "click .toggle-details" : "toggleDetails",
    "click .edit" : "editWant",
    "click .delete" : "deleteWant"
  },

  toggleDetails: function(e){
    $(this.el).find('.notes').toggle();
    e.preventDefault();
  },

  editWant: function(e){
    e.preventDefault();
  },

  deleteWant: function(e){
    e.preventDefault();
    var proceed = confirm("Are you sure you want to delete " + this.model.get('name') + "?");
    if (proceed) {
      this.clear();
    }
  },

  clear: function() {
    this.model.clear();
  },

  remove: function(){
    $(this.el).remove();
  }
});



// Top-level view for the entire app
window.AppView = Backbone.View.extend({

  el: $("#MainContent"),

  initialize: function() {
    this.render();
  },

  render: function() {
    window.wants.each(this.renderOne);
  },

  renderOne: function(want) {
    var view = new WantView({model: want});
    this.$("#WantList").append(view.render().el);
  }
});
