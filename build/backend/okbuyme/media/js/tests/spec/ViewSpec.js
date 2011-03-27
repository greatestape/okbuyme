describe("A Want view", function(){

  beforeEach(function(){
    this.want = new Want({ name: "want1", notes: "want1" });
  });

  it("should be rendered into a list item", function(){
    loadFixtures('want-fixture.html');
    var wantView = new WantView({model: this.want});
    var el = wantView.render().el;
    expect($(el)).toBe('li');
    expect($(el)).toContain('div.want');
    expect($(el).find('strong.name').text()).toEqual('want1');
  });
});
