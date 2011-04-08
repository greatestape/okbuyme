//
// views.js
// Define the app's views, which are pieces of the UI.
//


//
// A view for one Want (ie one entry in the wants list).
//
WantView = Backbone.View.extend({

  tagName: "li",

  template: function(){
    html = _.unescape($("#WantTemplate").html());
    return _.template(html);
  },

  initialize: function() {
    _.bindAll(this, "render");
    this.model.view = this;
  },

  render: function() {
    model_data = this.model.toJSON();
    var template = this.template();
    $(this.el).html(template(model_data));
    return this;
  },

  events: {
    "click .want" : "toggleDetails",
    "click .delete" : "deleteWant"
  },

  toggleDetails: function(e){
    e.preventDefault();
    if (!$(e.target).hasClass("delete")) {
      $(this.el)
        .toggleClass('open')
        .find('.details')
        .toggle();
    }
  },

  deleteWant: function(e){
    e.preventDefault();
    var proceed = confirm("Are you sure you want to delete " + this.model.get('name') + "?");
    if (proceed) {
      this.model.clear();
    }
  },

  remove: function(){
    $(this.el).slideUp('normal', function(){
      $(this).remove();
    });
  }
});


AddWantView = Backbone.View.extend({
  tagName: "div",
  id: "AddWantFormContainer",

  template: function(){
    html = _.unescape($("#AddWantFormTemplate").html());
    return _.template(html);
  },

  initialize: function() {
    _.bindAll(this, "render");
  },

  render: function() {
    $(this.el).html(this.template());
    return this;
  }
});


//
// A top-level view for the entire app
//
AppView = Backbone.View.extend({

  initialize: function() {
    this.render();
  },

  render: function() {
    okbuyme.app.wants.each(this.renderWant);
    this.renderAddForm();
  },

  renderWant: function(want) {
    var view = new WantView({model: want});
    $("#WantList").append(view.render().el);
  },

  renderAddForm: function(){
    var view = new AddWantView();
    $("#ListContainer").prepend(view.render().el);
  }
});
