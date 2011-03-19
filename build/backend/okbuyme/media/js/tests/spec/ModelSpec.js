describe("Want model", function() {

  var want;

  beforeEach(function(){
    want = new Want({
      name: "want1"
    });
  });

  it("should extend the Backbone native model correctly", function(){
    expect(want.get("name")).toEqual("want1");
  });

});
