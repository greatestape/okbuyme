describe("A Want view", function(){

  beforeEach(function(){
    this.want = new Want({ name: "want1", notes: "want1 notes" });
    loadFixtures('want-list.html');
    this.wantView = new WantView({model: this.want});
    this.$el = $(this.wantView.render().el);
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
    this.$el.find(".delete").trigger("click");
    expect(this.$el.hasClass("open")).toBeFalsy();
  });
});


describe("The App view", function(){

  beforeEach(function(){
    this.want1 = new Want({ name: "want1", notes: "want1" });
    this.want2 = new Want({ name: "want2", notes: "want2" });
    this.want3 = new Want({ name: "want3", notes: "want3" });
    this.wants = new WantList([this.want1, this.want2, this.want3]);
  });

  it("should render a list of Wants", function(){
    loadFixtures('want-list.html');
    okbuyme.app.wants = this.wants; // add to namespace
    new AppView();
    expect($("#WantList")).not.toBeEmpty();
    expect($("#WantList li").length).toEqual(3);
  });

});

