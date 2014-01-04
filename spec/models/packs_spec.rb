require 'spec_helper'

describe Packs do

  it 'should validate params' do
    Box.stub(:find).and_return(FactoryGirl.build(:box))
    Product.stub(:find).and_return(FactoryGirl.build(:product))
    pack = Packs.new( nil                                                   )
    pack.valid?.should == false
    pack = Packs.new( []                                                    )
    pack.valid?.should == false
    pack = Packs.new( {}                                                    )
    pack.valid?.should == false
    pack = Packs.new( [1]                                                   )
    pack.valid?.should == false
    pack = Packs.new( ['a', {'id'=>1,'order'=>1} ]                          )
    pack.valid?.should == false
    pack = Packs.new( ['1', {'id'=>1,'order'=>1}, 'invalid_node' ]           )
    pack.valid?.should == false
    pack = Packs.new( ['1', {'id'=>1,'order'=>1}, {'order'=>1} ]            )
    pack.valid?.should == false
    pack = Packs.new( ['1', {'id'=>1,'order'=>1}, {'id'=>'a','order'=>1} ]  )
    pack.valid?.should == false
    pack = Packs.new( ['1', {'id'=>1,'order'=>1}, {'id'=>1} ]               )
    pack.valid?.should == false
    pack = Packs.new( ['1', {'id'=>1,'order'=>1}, {'id'=>1,'order'=>'a'} ]  )
    pack.valid?.should == false
  end

  it 'should create box and products' do
    Box.should_receive(:find).once().with(1).and_return(FactoryGirl.build(:box))
    Product.should_receive(:find).once().with(1).and_return(FactoryGirl.build(:product))
    packs = Packs.new( ['1', {'id'=>1,'order'=>1}] )
    packs.valid?
    packs.box.name.should =~ /^Box\d+$/
    packs.products[0]['order'].should == 1
  end

end
