require 'spec_helper'

describe 'Packs View' do
  it 'should return error if box is too small' do
    FactoryGirl.create(:product, width:10)
    FactoryGirl.create(:box, volume:1)
    visit '/'
    find('#product_list table tr.item_row .check').click
    find('#box_list table tr.item_row .check').click
    find('div.packs div.title a.pack').click
    find('div.packs div.title span.message').should have_content('Box is too small')
  end

  it 'should ignore products with volum 0' do
    FactoryGirl.create(:product, width:0, height:0, depth:0)
    FactoryGirl.create(:box, volume:1)
    visit '/'
    find('#product_list table tr.item_row .check').click
    find('#box_list table tr.item_row .check').click
    find('div.packs div.title a.pack').click
    find('div.packs div.title span.message').should have_content('200')
    find('div.packs').should_not have_css('div.list')
  end

  it 'should request and show result for valid data' do
    FactoryGirl.create(:product, width:1, height:1, depth:1)
    FactoryGirl.create(:box, volume:1)
    visit '/'
    find('#product_list table tr.item_row .check').click
    find('#box_list table tr.item_row .check').click
    find('div.packs div.title a.pack').click
    find('div.packs div.title span.message').should have_content('200')
    find('div.packs div.list table').should have_css('tr.item_row')
  end
end
