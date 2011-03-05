//
// app.js
//
// Requirements:
//    * jQuery, Underscore, Backbone
//    * app-db.js, app-models.js, app-views.js
//


$(function(){
  _.each(window.wantList, function(want){
    window.wants.add(want);
  });
  //window.app = new AppView();
});
