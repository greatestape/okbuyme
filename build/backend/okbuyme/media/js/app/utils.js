//
// utils.js
// Various helper methods, added into the Underscore namespace.
//


_.mixin({
  log : function(){
    this.log.history = this.log.history || []; // store logs to an array for reference
    this.log.history.push(arguments);
    if(window.console) console.log( Array.prototype.slice.call(arguments) );
  },

  make_base_auth : function(user, password) {
    var token = user + ':' + password;
    var hash = Base64.encode(token);
    return "Basic " + hash;
  }
});
