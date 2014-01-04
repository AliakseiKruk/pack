require 'spec_helper'

describe PacksController do
  before :each do
    @params = { 'todo' => [1, {'id'=>1,'order'=>1}, {'id'=>2,'order'=>2}] }
    @p1 = FactoryGirl.build(:product)
    @p2 = FactoryGirl.build(:product)
    @b1 = FactoryGirl.build(:box)
  end

  it 'should return error messages if there are not params' do
    response = post(:pack)
    JSON.parse(response.body)['error'].keys.size.should > 0
  end

  it 'should validate all params' do
    Box.stub(:find).with(1).and_return(@b1)
    Product.stub(:find).with(1).and_return(@p1)
    response = post(:pack, {'todo'=>[]} )
    JSON.parse(response.body)['error'].keys.size.should > 0
    response = post(:pack, {'todo'=>[1]} )
    JSON.parse(response.body)['error'].keys.size.should > 0
    response = post(:pack, {'todo'=>['a', {'id'=>1,'order'=>1} ] } )
    JSON.parse(response.body)['error'].keys.size.should > 0
    response = post(:pack, {'todo'=>['1', {'id'=>1,'order'=>1}, 'invali_node' ] } )
    JSON.parse(response.body)['error'].keys.size.should > 0
    response = post(:pack, {'todo'=>['1', {'id'=>1,'order'=>1}, {'order'=>1} ] } )
    JSON.parse(response.body)['error'].keys.size.should > 0
    response = post(:pack, {'todo'=>['1', {'id'=>1,'order'=>1}, {'id'=>'a','order'=>1} ] } )
    JSON.parse(response.body)['error'].keys.size.should > 0
    response = post(:pack, {'todo'=>['1', {'id'=>1,'order'=>1}, {'id'=>1} ] } )
    JSON.parse(response.body)['error'].keys.size.should > 0
    response = post(:pack, {'todo'=>['1', {'id'=>1,'order'=>1}, {'id'=>1,'order'=>'a'} ] } )
    JSON.parse(response.body)['error'].keys.size.should > 0
  end

  it 'should return empty result if box is stored as 0 volume' do
    Product.stub(:find).with(@params['todo'][1]['id']).and_return(@p1)
    Product.stub(:find).with(@params['todo'][2]['id']).and_return(@p2)
    Box.stub(:find).with(@params['todo'][0]).and_return(FactoryGirl.build(:box, volume:0))
    response = post(:pack, @params )
    assert_response :success
    response.content_type.should == 'application/json'
    response.body.should == '{"boxes":[]}'
  end

  it 'should return error if box is too small for the biggest product' do
    Product.stub(:find).with(@params['todo'][1]['id']).and_return(FactoryGirl.build(:product, width:10))
    Product.stub(:find).with(@params['todo'][2]['id']).and_return(@p2)
    Box.stub(:find).with(@params['todo'][0]).and_return(@b1)
    response = post(:pack, @params )
    assert_response :success
    response.content_type.should == 'application/json'
    response.body.should == '{"error":"Box is too small"}'
  end

  it 'should ignore products which were order more then available' do
    Calculator.should_receive(:calculate).with(@b1.volume,[{ 'id'=>@params['todo'][1]['id'], 'order'=>@params['todo'][1]['order'], 'volume'=>(@p1.width * @p1.height * @p1.depth) }])
    Product.stub(:find).with(@params['todo'][1]['id']).and_return(@p1)
    Product.stub(:find).with(@params['todo'][2]['id']).and_return(@p2)
    Box.stub(:find).with(@params['todo'][0]).and_return(@b1)
    response = post(:pack, @params )
  end

  it 'should return result in json format' do
    Product.stub(:find).with(@params['todo'][1]['id']).and_return(@p1)
    Product.stub(:find).with(@params['todo'][2]['id']).and_return(FactoryGirl.build(:product, stock_level:10))
    Box.stub(:find).with(@params['todo'][0]).and_return(FactoryGirl.build(:box, volume:100))
    response = post(:pack, @params )
    assert_response :success
    response.content_type.should == 'application/json'
    response.body.should =~ /^\{"boxes":\[/
  end
end
