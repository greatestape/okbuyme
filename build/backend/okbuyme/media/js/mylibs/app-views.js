// app-views.js


//-------------- VIEWS --------------

// View for one Item (ie one entry in the items list).
window.ItemView = Backbone.View.extend({

  tagName: "li",
  className: "item-row",

  template: _.template($('#ItemTemplate').html()),

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
    //"hover .toggle-details" : "toggleDetails", // TODO activate when hovering over entire row, which is `this`
    "click .toggle-notes" : "toggleNotes",
    "click .edit" : "edit",
    "click .delete" : "delete",
  },

  toggleNotes: function(e){
    $(this.el).find('.notes').toggle();
    e.preventDefault();
  },

  edit: function(e){
    e.preventDefault();
  },

  delete: function(e){
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
    window.items.each(this.renderOne);
  },

  renderOne: function(item) {
    var view = new ItemView({model: item});
    this.$("#ItemList").append(view.render().el);
  }
});
