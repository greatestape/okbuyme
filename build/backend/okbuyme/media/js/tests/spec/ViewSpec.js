describe("A Want view", function(){

  beforeEach(function(){
    this.want = new Want({ name: "want1", notes: "want1" });
  });

  it("should be rendered into a list item", function(){
    loadFixtures('want-list.html');
    var wantView = new WantView({model: this.want});
    var el = wantView.render().el;
    expect($(el)).toBe('li');
    expect($(el)).toContain('div.want');
    expect($(el).find('strong.name').text()).toEqual('want1');
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

