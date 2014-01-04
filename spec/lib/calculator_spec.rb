require 'spec_helper'

describe Calculator do
  before :each do
    @box = 10
    @p1 = { 'id'=>1, 'order'=>1, 'volume'=>8 }
    @p2 = { 'id'=>2, 'order'=>2, 'volume'=>4 }
    @p3 = { 'id'=>3, 'order'=>4, 'volume'=>2 }
  end

  it 'should validate if box is big enough' do
    Calculator.calculate(5, [@p1, @p2, @p3]).should == {'error' => 'Box is too small'}
  end

  context 'Algorithm should correctly calculate following situation' do
    it 'box: 10, products: 1 by 8, 2 by 4, 4 by 2' do
      result = {"boxes"=>[{"box"=>[ {"id"=>1, "qnt"=>1},
                                    {"id"=>3, "qnt"=>1}],
                                    "full"=>100},
                          {"box"=>[ {"id"=>2, "qnt"=>2},
                                    {"id"=>3, "qnt"=>1}],
                                    "full"=>100},
                          {"box"=>[ {"id"=>3, "qnt"=>2}],
                                    "full"=>40}]}
      Calculator.calculate(@box, [@p1, @p2, @p3]).should == result
    end

    it 'box: 11, products: 1 by 8, 2 by 4, 4 by 2' do
      result = {"boxes"=>[{"box"=>[ {"id"=>1, "qnt"=>1},
                                    {"id"=>3, "qnt"=>1}],
                                    "full"=>90},
                          {"box"=>[ {"id"=>2, "qnt"=>2},
                                    {"id"=>3, "qnt"=>1}],
                                    "full"=>90},
                          {"box"=>[ {"id"=>3, "qnt"=>2}],
                                    "full"=>36}]}
      Calculator.calculate(11, [@p1, @p2, @p3]).should == result
    end

    it 'box: 10, products: 1 by 7, 2 by 4, 4 by 2' do
      result = {"boxes"=>[{"box"=>[ {"id"=>1, "qnt"=>1},
                                    {"id"=>3, "qnt"=>1}],
                                    "full"=>90},
                          {"box"=>[ {"id"=>2, "qnt"=>2},
                                    {"id"=>3, "qnt"=>1}],
                                    "full"=>100},
                          {"box"=>[ {"id"=>3, "qnt"=>2}],
                                    "full"=>40}]}
      Calculator.calculate(@box, [@p1.merge({'volume'=>7}), @p2, @p3]).should == result
    end

    it 'box: 13, products: 1 by 7, 2 by 5, 4 by 3' do
      result = {"boxes"=>[{"box"=>[ {"id"=>1, "qnt"=>1},
                                    {"id"=>2, "qnt"=>1}],
                                    "full"=>92},
                          {"box"=>[ {"id"=>2, "qnt"=>1},
                                    {"id"=>3, "qnt"=>2}],
                                    "full"=>84},
                          {"box"=>[ {"id"=>3, "qnt"=>2}],
                                    "full"=>46}]}
      Calculator.calculate(13, [@p1.merge({'volume'=>7}), @p2.merge({'volume'=>5}), @p3.merge({'volume'=>3})]).should == result
    end
  end
end
