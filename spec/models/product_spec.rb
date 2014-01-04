require 'spec_helper'

describe Product do
  before :each do
    @params = {'name'=>'ValidName', 'width'=>'1', 'height'=>'1', 'depth'=>'1', 'weight'=>'1', 'stock_level'=>'1'}
  end

  it { should validate_uniqueness_of(:name) }

  it 'should validate if attributes exist' do
    product = Product.new
    product.valid?
    product.errors.size.should > 0
  end

  it 'should validate if name exist' do
    @params.delete('name')
    product = Product.new(@params)
    product.valid?
    product.errors.size.should > 0
    product = Product.new(@params.merge({'name'=>''}))
    product.valid?
    product.errors.size.should > 0
  end

  it 'should check if values are greater then -1' do
    ['width', 'height', 'depth', 'weight', 'stock_level'].each do |key|
      [-1, 'a', 1.1].each do |value|
        params = @params.dup
        product = Product.new( params.merge({ key => value }) )
        product.valid?
        product.errors.size.should > 0
      end
    end
  end

end
