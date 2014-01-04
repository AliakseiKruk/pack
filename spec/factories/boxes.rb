# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :box do
    sequence(:name) {|n| "Box#{n}" }
    volume 1
  end
end
