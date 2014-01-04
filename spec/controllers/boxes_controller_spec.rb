require 'spec_helper'

describe BoxesController do
  context 'REST' do
    context 'index' do
      before :each do
        @b1 = FactoryGirl.build(:box)
        @b2 = FactoryGirl.build(:box)
        Box.stub(:all).and_return([@b1, @b2])
        @result = [@b1, @b2].to_json
      end

      it 'should returns json' do
        response = get(:index)
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == @result
      end

      it 'should ignore params' do
        response = get(:index, {:id => @b1.id})
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == @result
      end

      it 'should return [] instead of 404 or Exception if DB is empty' do
        Box.stub(:all).and_return([])
        response = get(:index)
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == '[]'
      end
    end

    context 'create' do
      before :each do
        @params = {'name'=>'ValidName', 'volume'=>'1', 'id'=>'0'}
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
        params = @params.dup
        params.delete('volume')
        payloads.push(params)
        payloads.push(@params.merge({ 'volume' => 'invalid' }))
        payloads.push(@params.merge({ 'volume' => -1 }))
        payloads.each do |p|
          response = post(:create, {'box'=>p} )
          JSON.parse(response.body)['error'].keys.size.should > 0
        end
      end

      it 'should correctly save box if data is valid' do
        box = double('box')
        box.stub(:valid?).and_return(true)
        params = @params.dup
        params.delete('id')
        Box.should_receive(:new).with(params).and_return(box)
        box.should_receive(:save)
        box.should_receive(:reload)
        box.should_receive(:id).and_return(@params['id'].to_i)
        response = post(:create, {'box'=>@params} )
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == '{"id":' + @params['id'] + '}'
      end
    end

    context 'update' do
      before :each do
        @params = {'name'=>'ValidName', 'volume'=>'1', 'id'=>'1'}
      end

      it 'should raise an Exception if there are not params' do
        Box.should_receive(:find).and_return(FactoryGirl.build(:box))
        response = put(:update, {'id'=>@params['id'], 'box' => { 'id'=>@params['id'] }})
          JSON.parse(response.body)['error'].keys.size.should > 0
      end

      it 'should return error messages if there is invalid data' do
        Box.stub(:find).and_return(FactoryGirl.build(:box))
        payloads = []
        payloads.push(@params.merge({ 'name' => '' }))
        payloads.push(@params.merge({ 'volume' => 'invalid' }))
        payloads.push(@params.merge({ 'volume' => -1 }))
        payloads.each do |p|
          response = put(:update, {'id'=>@params['id'], 'box' => p.merge({ 'id'=>@params['id']  })} )
          JSON.parse(response.body)['error'].keys.size.should > 0
        end
        Box.should_receive(:find).with(0).and_return([])
        response = put(:update, {'id'=>'0', 'box' => @params.merge({ 'id'=>'0' })} )
        JSON.parse(response.body)['error'].keys.size.should > 0
      end

      it 'should correctly save box if data is valid' do
        box = double('box')
        box.stub(:class).and_return(Box)
        Box.should_receive(:find).with(@params['id'].to_i).and_return(box)
        box.should_receive(:name=  ).with(@params['name'])
        box.should_receive(:volume=).with(@params['volume'])
        box.should_receive(:save)
        box.should_receive(:reload)
        box.should_receive(:id).and_return(@params['id'].to_i)
        box.should_receive(:valid?).and_return(true)
        response = put(:update, {'id'=>@params['id'], 'box' => @params} )
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
        payloads = ['a', -1, 0 ]
        payloads.each do |p|
          response = delete(:destroy, {'id'=>p} )
          JSON.parse(response.body)['error'].keys.size.should > 0
        end
      end

      it 'should correctly delete product if id is valid' do
        box = double('box')
        Box.should_receive(:find).with(@params['id'].to_i).and_return(box)
        box.should_receive(:valid?).and_return(true)
        box.should_receive(:destroy)
        box.should_receive(:id).and_return(@params['id'].to_i)
        response = delete(:destroy, @params )
        assert_response :success
        response.content_type.should == 'application/json'
        response.body.should == '{"id":' + @params['id'] + '}'
      end
    end
  end
end
