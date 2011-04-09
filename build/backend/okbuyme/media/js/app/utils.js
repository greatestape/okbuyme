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

  // Unescape some HTML entities provided string `str`. Used when compiling
  // Underscore templates. When running regularly in the browser, the templates
  // are preexisting in the DOM and do not present a problem. But when running
  // in the jasmine test suite, the templates are loaded via AJAX and added to
  // the DOM dynamically, and at that point extracting their contents via
  // jQuery's $.html() results in the HTML entities (specifically < and > used
  // in Underscore's templating) being escaped (into &lt; and &gt;) rendering
  // that string useless for using as a template. So this function converts
  // them back. TODO I'm still not entirely convinced this is the right thing
  // to do, since it's involved adding stuff to app code just for the sake of
  // making tests happy.
  unescape: function(str){
    var lre = /&lt;/g,
        gre = /&gt;/g;
    return typeof str == "string" ? str.replace(lre, "<").replace(gre, ">") : str;
  }
});
