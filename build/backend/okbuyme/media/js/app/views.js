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
    var template = _.template(html);
    return template;
  },

  initialize: function() {
    _.bindAll(this, "render");
    this.model.view = this;
  },

  render: function() {
    model_data = this.model.toJSON();
    var template = this.template();
    var html = $(this.el).html(template(model_data));
    return this;
  },

  events: {
    "click .want" : "toggleDetails",
  },

  toggleDetails: function(e){
    if (!$(e.target).hasClass("delete")) {
      $(this.el)
        .toggleClass('open')
        .find('.details')
        .toggle();
    }
    e.preventDefault();
  }
});


//
// A top-level view for the entire app
//
AppView = Backbone.View.extend({

  el: $("#MainContent"),

  initialize: function() {
    this.render();
  },

  render: function() {
    okbuyme.app.wants.each(this.renderOne);
  },

  renderOne: function(want) {
    var view = new WantView({model: want});
    this.$("#WantList").append(view.render().el);
  }
});
