# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:name) {|n| "Product#{n}" }
    sequence(:width) {|n| n }
    height 1
    depth 1
    weight 1
    stock_level 1
  end
end
