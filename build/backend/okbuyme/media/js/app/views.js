//
// views.js
// Define the app's views, which are pieces of the UI.
//


//
// A view for one Want (ie one entry in the wants list).
//
WantView = Backbone.View.extend({

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

  //events: {//{{{
    //"click .details"  : "toggleDetails",
    //"click .edit"     : "editWant",
    //"click .delete"   : "deleteWant"
  //},

  //toggleDetails: function(e){

    //$(this.el)
      //.toggleClass('open')
      //.find('.want-details')
      //.toggle();
    //e.preventDefault();
  //},

  //editWant: function(e){
    //e.preventDefault();
  //},

  //deleteWant: function(e){
    //e.preventDefault();
    //var proceed = confirm("Are you sure you want to delete " + this.model.get('name') + "?");
    //if (proceed) {
      //this.clear();
    //}
  //},

  //clear: function() {
    //this.model.clear();
  //},

  //remove: function(){
    //$(this.el).slideUp('normal', function(){
      //$(this).remove();
    //});
  //}//}}}
});

//
// A view to present the add form
//
//AddView = Backbone.View.extend({//{{{
  //el: $("#AddWantFormContainer"),

  //template: _.template($('#AddWantFormTemplate').html()),

  //events: {
    //"click #AddWant" : "addWant"
  //},

  //initialize: function(){
    //this.render();
  //},

  //render: function(){
    //var html = $(this.el).html(this.template());
  //},

  //addWant: function(e) {
    //e.preventDefault();
    //var $target = $(e.target),
        //isOpen = $target.hasClass("open");
    //if (isOpen) { // close it
      //$(this.el)
        //.find('form')
        //.slideToggle(function(){
          //$target.removeClass('open').addClass('closed');
        //});
    //} else { // open it
      //$target.removeClass('closed').addClass('open');
      //$(this.el).find('form').slideToggle();
    //}
  //}
//});//}}}


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
    //this.renderAddForm();
  },

  renderOne: function(want) {
    var view = new WantView({model: want});
    this.$("#WantList").append(view.render().el);
  },

  //renderAddForm: function(){
    //var view = new AddView();
    //this.$("#AddWantFormContainer").append(view);
  //}
});
