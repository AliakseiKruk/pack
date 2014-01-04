class Box < ActiveRecord::Base
  validates :name  , presence: true, uniqueness: true
  validates :volume, presence: true, numericality: { only_integer: true, greater_than: -1 }
end
