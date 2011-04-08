describe("A Want view", function(){

  beforeEach(function(){
    window.origConfirm = window.confirm;
    loadFixtures('want-template.html');
    want = new Want({ name: "want1", notes: "want1 notes" });
    wantView = new WantView({model: want});
    this.$el = $(wantView.render().el);
  });

  afterEach(function(){
    window.confirm = window.origConfirm;
  });

  it("should be rendered into a list item", function(){
    expect(this.$el).toBe('li');
    expect(this.$el).toContain('.want');
    expect(this.$el.find('.name').text()).toEqual('want1');
    expect(this.$el.find('.details').text()).toEqual('want1 notes');
  });

  it("should have its notes field initially hidden", function(){
    expect(this.$el.find(".details").is(":visible")).toBeFalsy();
  });

  it("should make its notes field visible when clicked on", function(){
    this.$el.find(".want").trigger("click");
    expect(this.$el.hasClass("open")).toBeTruthy();
  });

  it("should not make its notes field visible when its delete link is clicked on", function(){
    window.confirm = function(){}; // so it does not appear during test run
    this.$el.find(".delete").trigger("click");
    expect(this.$el.hasClass("open")).toBeFalsy();
  });

  it("should present a confirm dialog when the delete link is clicked", function(){
    window.confirm = jasmine.createSpy();
    this.$el.find(".delete").trigger("click");
    expect(window.confirm).toHaveBeenCalled();
  });
});


describe("The Add Want form view", function(){

  beforeEach(function(){
    loadFixtures("want-list.html", "add-want-form-template.html");
    addWantView = new AddWantView();
    this.$el = $(addWantView.render().el);
  });

  it("should render into the appropriate div", function(){
    expect(this.$el).toBe('div');
    expect(this.$el).toContain("form");
  });
});


describe("The App view", function(){

  beforeEach(function(){
    window.origConfirm = window.confirm;
    loadFixtures("want-list.html", "want-template.html", "add-want-form-template.html");
    want1 = new Want({ name: "want1", notes: "", resource_uri: "/wants/1" });
    want2 = new Want({ name: "want2", notes: "", resource_uri: "/wants/2" });
    want3 = new Want({ name: "want3", notes: "", resource_uri: "/wants/3" });
    okbuyme.app.wants = new WantList([want1, want2, want3]);
    new AppView();
    this.server = sinon.fakeServer.create();
  });

  afterEach(function(){
    window.confirm = window.origConfirm;
  });

  it("should render a list of Wants", function(){
    expect($("#WantList")).not.toBeEmpty();
    expect($("#WantList li").length).toEqual(3);
  });

  it("should remove a Want from the list when it's deleted", function(){
    window.confirm = function(){ return true; } // simulate accepting dialog
    this.server.respondWith("DELETE", "/wants/2", [204, {}, '']);

    runs(function(){
      $("#WantList li:eq(1) .delete").trigger("click");
      this.server.respond();
    });

    waits(500); // wait for slideUp(), which takes "normal" == 400ms

    runs(function(){
      expect($("#WantList li").length).toEqual(2);
    });
  });

  it("should render the add Want form", function(){
    expect($("#AddWantFormContainer").length).toEqual(1);
  });
});
