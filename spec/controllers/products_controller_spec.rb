require 'spec_helper'

describe ProductsController do
  context 'REST' do
    context 'index' do
      before :each do
        @p1 = FactoryGirl.build(:product)
        @p2 = FactoryGirl.build(:product)
        Product.stub(:all).and_return([@p1, @p2])
        @result = [@p1, @p2].to_json
      end

      it 'should returns json' do
        response = get(:index)
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == @result
      end

      it 'should ignore params' do
        response = get(:index, {:id => @p1.id})
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == @result
      end

      it 'should return [] instead of 404 or Exception if DB is empty' do
        Product.stub(:all).and_return([])
        response = get(:index)
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == '[]'
      end
    end

    context 'create' do
      before :each do
        @params = {'name'=>'ValidName', 'width'=>'1', 'height'=>'1', 'depth'=>'1', 'weight'=>'1', 'stock_level'=>'1', 'id'=>'0'}
      end

      it 'should raise an Exception if there are not params' do
        expect{ post(:create) }.to raise_error(ActionController::ParameterMissing)
      end

      it 'should return error messages if there is invalid data' do
        payloads = []
        params = @params.dup
        params.delete('name')
        payloads.push(params)
        payloads.push(@params.merge({ 'name' => '' }))
        ['width', 'height', 'depth', 'weight', 'stock_level'].each do |key|
          params = @params.dup
          params.delete(key)
          payloads.push(params)
          payloads.push(@params.merge({ key => 'invalid' }))
          payloads.push(@params.merge({ key => -1 }))
        end
        payloads.each do |p|
          response = post(:create, {'product'=>p})
          JSON.parse(response.body)['error'].keys.size.should > 0
        end
      end

      it 'should correctly save product if data is valid' do
        product = double('product')
        product.stub(:class).and_return(Product)
        product.stub(:valid?).and_return(true)
        params = @params.dup
        params.delete('id')
        Product.should_receive(:new).with(params).and_return(product)
        product.should_receive(:save)
        product.should_receive(:reload)
        product.should_receive(:id).and_return(@params['id'].to_i)
        response = post(:create, {'product'=>@params} )
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == '{"id":' + @params['id'] + '}'
      end
    end

    context 'update' do
      before :each do
        @params = {'name'=>'ValidName', 'width'=>'1', 'height'=>'1', 'depth'=>'1', 'weight'=>'1', 'stock_level'=>'1', 'id'=>'1'}
      end

      it 'should raise an Exception if there are not params' do
        response = put(:update, { 'id'=>@params['id']  })
        JSON.parse(response.body)['error'].keys.size.should > 0
      end

      it 'should return error messages if there is invalid data' do
        payloads = []
        params = @params.dup
        params.delete('name')
        payloads.push(params)
        payloads.push(@params.merge({ 'name' => '' }))
        ['width', 'height', 'depth', 'weight', 'stock_level'].each do |key|
          params = @params.dup
          params.delete(key)
          payloads.push(params)
          payloads.push(@params.merge({ key => 'invalid' }))
          payloads.push(@params.merge({ key => -1 }))
        end
        payloads.each do |p|
          response = put(:update, {'id'=>@params['id'], 'product' => p.merge({ 'id'=>@params['id']  })} )
          JSON.parse(response.body)['error'].keys.size.should > 0
        end
        response = put(:update, {'id'=>'0', 'product' => @params.merge({ 'id'=>'0' })} )
        JSON.parse(response.body)['error'].keys.size.should > 0
      end

      it 'should correctly save product if data is valid' do
        product = double('product')
        product.stub(:class).and_return(Product)
        product.stub(:valid?).and_return(true)
        Product.should_receive(:find).with(@params['id'].to_i).and_return(product)
        product.should_receive(:name=       ).with(@params['name'])
        product.should_receive(:width=      ).with(@params['width'])
        product.should_receive(:height=     ).with(@params['height'])
        product.should_receive(:depth=      ).with(@params['depth'])
        product.should_receive(:weight=     ).with(@params['weight'])
        product.should_receive(:stock_level=).with(@params['stock_level'])
        product.should_receive(:save)
        product.should_receive(:reload)
        product.should_receive(:id).and_return(@params['id'].to_i)
        response = put(:update, {'id'=>@params['id'], 'product'=>@params} )
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == '{"id":' + @params['id'] + '}'
      end
    end

    context 'destroy' do
      before :each do
        @params = {'id'=>'1'}
      end

      it 'should return error message if id is invalid' do
        payloads = ['a', -1 ]
        payloads.each do |p|
          response = delete(:destroy, {'id'=>p} )
          JSON.parse(response.body)['error'].keys.size.should > 0
        end
      end

      it 'should correctly delete product if id is valid' do
        product = double('product')
        product.stub(:class).and_return(Product)
        Product.should_receive(:find).with(@params['id'].to_i).and_return(product)
        product.should_receive(:valid?).and_return(true)
        product.should_receive(:destroy)
        product.should_receive(:id).and_return(@params['id'].to_i)
        response = delete(:destroy, @params )
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == '{"id":' + @params['id'] + '}'
      end
    end
  end
end
