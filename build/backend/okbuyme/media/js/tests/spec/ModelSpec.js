describe("A Want model", function() {

  beforeEach(function(){
    this.server = sinon.fakeServer.create();
    this.want = new Want({ name: "want1", resource_uri: "/wants/1" });
  });

  afterEach(function() {
    this.server.restore();
  });

  it("should expose an attribute", function(){
    expect(this.want.get("name")).toEqual("want1");
  });

  it("should be able to be deleted", function(){
    // set how the fake server should respond to a DELETE request
    this.server.respondWith("DELETE", "/wants/1", [204, {}, '']);

    // set a fake callback method to spy on
    var destroyCallback = sinon.spy();
    this.want.bind('destroy', destroyCallback); // "destroy" event fired in success callback of Model.destroy()

    // issue the delete
    this.want.clear();

    // tell the fake server to respond
    this.server.respond();

    expect(destroyCallback.called).toBeTruthy();
  });
});


describe("A WantList collection", function() {

  beforeEach(function(){
    this.server = sinon.fakeServer.create();

    this.want1 = new Want({ name: "want1", resource_uri: "/wants/1" });
    this.want2 = new Want({ name: "want2", resource_uri: "/wants/2" });
    this.want3 = new Want({ name: "want3", resource_uri: "/wants/3" });
    this.wants = new WantList([this.want1, this.want2, this.want3]);
  });

  afterEach(function(){
    this.server.restore();
  });

  it("should contain the Wants it was created with", function(){
    expect(this.wants.at(1).get("name")).toEqual("want2");
  });

  it("should not contain a model after the model is deleted", function(){
    this.server.respondWith("DELETE", "/wants/2", [204, {}, '']);
    this.want2.clear();
    this.server.respond();
    expect(this.wants.length).toEqual(2);
    expect(this.wants).not.toContain(this.want2);
  });
});
