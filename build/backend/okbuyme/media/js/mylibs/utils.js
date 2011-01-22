_.mixin({
  log : function(){
    this.log.history = this.log.history || []; // store logs to an array for reference
    this.log.history.push(arguments);
    if(window.console) console.log( Array.prototype.slice.call(arguments) );
  }
});
