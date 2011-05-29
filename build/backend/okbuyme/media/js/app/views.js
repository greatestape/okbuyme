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
        html = $("#WantTemplate").html();
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


//
// A view for the form to add a Want.
//
AddWantView = Backbone.View.extend({
    tagName: "div",
    id: "AddWantFormContainer",

    template: function(){
        html = $("#AddWantFormTemplate").html();
        return _.template(html);
    },

    initialize: function() {
        _.bindAll(this, "render", "handleSave");
    },

    render: function() {
        $(this.el).html(this.template());
        return this;
    },

    events: {
        "click #AddWantFormToggle": "toggleAddWantForm",
        "submit #AddWantForm" : "submit"
    },

    // Display form errors. Note this handles both errors from jQuery's $.ajax()
    // and form validation errors. Note also that the validation error handling
    // is currently heavily tied to the model and could be more robust.
    handleError: function(model, errorObj){
        if (errorObj.readyState) { // error from $.ajax()
            _.displayGenericError();
        } else { // form validation error
            var html = $("#FormErrorTemplate").html(),
            template = _.template(html);

            if (errorObj.name) {
                var msg = template({"error": errorObj.name});
                $("#id_name").after(msg);
            }
        }
    },

    // Display messages and reset form when Want is successfully saved
    handleSave: function(model){
        this.render();

        var html = $("#SuccessMessageTemplate").html(),
        template = _.template(html),
        msg = template({"message": "Your item was successfully saved."});
        $(this.el).parent().before(msg);

        // TODO not sure if collection refreshes, or how to update page
    },

    toggleAddWantForm: function(e) {
        e.preventDefault();
        $("#AddWantForm").slideToggle();
    },

    submit: function(e) {
        e.preventDefault();
        _.removeErrorMessages();

        var name = $("#id_name").val(),
        notes = $("#id_notes").val();

        var want = new Want({
            "name": name,
            "notes": notes
        });

        want.doSave(this);
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
