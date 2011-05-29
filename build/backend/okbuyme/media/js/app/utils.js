//
// utils.js
// Various helper methods, added into the Underscore namespace.
//


_.mixin({
    // Enhanced/safe log function
    log : function(){
        this.log.history = this.log.history || []; // store logs to an array for reference
        this.log.history.push(arguments);
        if(window.console) console.log( Array.prototype.slice.call(arguments) );
    },

    displayGenericError: function(){
        var html = $("#GenericErrorTemplate").html();
        $("#ListContainer").before(html);
    },

    removeErrorMessages: function(){
        $(".error-message").remove();
    }
});
