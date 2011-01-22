//
// app.js
//
// Requirements:
//    * jQuery, Underscore, Backbone
//    * app-db.js, app-models.js, app-views.js
//


$(function(){
for (var i = 0, max = fakeData.items.length; i < max; i++) {
  window.items.add(fakeData.items[i]);
}
window.app = new AppView;
});
