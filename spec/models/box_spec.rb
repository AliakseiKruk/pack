require 'spec_helper'

describe Box do

  it { should validate_uniqueness_of(:name) }

  it 'should validate if attributes exist' do
    box = Box.new
    box.valid?
    box.errors.size.should > 0
  end

  it 'should validate if name exist' do
    box = Box.new(volume:1)
    box.valid?
    box.errors.size.should > 0
    box = Box.new(name:'', volume:1)
    box.valid?
    box.errors.size.should > 0
  end

  it 'should check if volume is greater then -1' do
    box = Box.new( name:'Name', volume:-1 )
    box.valid?
    box.errors.size.should > 0
    box = Box.new( name:'Name', volume:'a' )
    box.valid?
    box.errors.size.should > 0
    box = Box.new( name:'Name', volume:1.1 )
    box.valid?
    box.errors.size.should > 0
  end

end
