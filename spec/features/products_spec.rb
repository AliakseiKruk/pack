require 'spec_helper'

describe 'Products View' do
  before :each do
    visit '/'
    @model = Product
    @entity = 'product'
    @entities = 'products'
  end

  it 'should show list after load' do
    page.should     have_selector("##{@entity}_list")
    page.should_not have_selector("##{@entity}_form")
    page.should     have_css("div.#{@entities} div.title a.load")
    page.should     have_css("div.#{@entities} div.title a.add")
    page.should_not have_css("div.#{@entities} div.title a.cancel")
    page.should_not have_css("div.#{@entities} div.title a.save")
  end

  it 'should show form after clicking Add and then hide form after clicking Cancel' do
    find("div.#{@entities} div.title").find('a.add').click
    page.should_not have_selector("##{@entity}_list")
    page.should     have_selector("##{@entity}_form")
    page.should_not have_css("div.#{@entities} div.title a.load")
    page.should_not have_css("div.#{@entities} div.title a.add")
    page.should     have_css("div.#{@entities} div.title a.cancel")
    page.should     have_css("div.#{@entities} div.title a.save")
    find("div.#{@entities} div.title").find('a.cancel').click
    page.should     have_selector("##{@entity}_list")
    page.should_not have_selector("##{@entity}_form")
    page.should     have_css("div.#{@entities} div.title a.load")
    page.should     have_css("div.#{@entities} div.title a.add")
    page.should_not have_css("div.#{@entities} div.title a.cancel")
    page.should_not have_css("div.#{@entities} div.title a.save")
  end

  it 'should load new items after clicking Reload' do
    page.should_not have_selector("##{@entity}_list table tr.item_row")
    @model.stub(:all).and_return([FactoryGirl.build(@entity.to_sym)])
    find("div.#{@entities} div.title").find('a.load').click
    page.should have_selector("##{@entity}_list table tr.item_row")
  end

  context 'Form' do
    it 'should save product if form is filled with valid data' do
      find("div.#{@entities} div.title").find('a.add').click
      find("div.#{@entities} div.title").find('a.save').click
      sleep(3)
      entity = @model.find_by(name:'Name')
      entity.class.should == @model
      page.should have_selector("##{@entity}_list")
    end

    it 'should not save product if form is filled with incorrect values' do
      @model.should_not_receive(:new)
      find("div.#{@entities} div.title").find('a.add').click
      find("div##{@entity}_form div.name input").set('')
      find("div.#{@entities} div.title").find('a.save').click
      sleep(3)
    end

    it 'should not save product with existing name' do
      find("div.#{@entities} div.title").find('a.add').click
      find("div.#{@entities} div.title").find('a.save').click
      sleep(3)
      find("div.#{@entities} div.title").find('a.add').click
      find("div.#{@entities} div.title").find('a.save').click
      sleep(3)
      find("div.#{@entities} div.title span.message").should have_content('{"name":["has already been taken"]}')
    end
  end

  context 'List' do
    it 'should open edit form by clicking on name' do
      @model.stub(:all).and_return([FactoryGirl.build(@entity.to_sym, name:'Testum')])
      find("div.#{@entities} div.title").find('a.load').click
      find("##{@entity}_list table tr.item_row").find('a.edit').click
      find("div##{@entity}_form div.name input").value.should == 'Testum'
    end

    it 'should delete entity by clicking X next to name' do
      FactoryGirl.create(@entity.to_sym, id:12345)
      @model.all.size.should == 1
      find("div.#{@entities} div.title").find('a.load').click
      find("##{@entity}_list table tr.item_row").find('a.delete').click
      sleep(3)
      @model.all.size.should == 0
    end

    it 'should decrease availabilty while increasing order' do
      @model.stub(:all).and_return([FactoryGirl.build(@entity.to_sym, stock_level:1)])
      find("div.#{@entities} div.title").find('a.load').click
      within("##{@entity}_list table tr.item_row") do
        find('.available').should have_content('1')
        find('.order').value.should == '0'
        find('.check').click
        find('.available').should have_content('0')
        find('.order').value.should == '1'
      end
    end
  end
end

