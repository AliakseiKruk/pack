class Product < ActiveRecord::Base
  validates :name       , presence: true, uniqueness: true
  validates :width      , presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :height     , presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :depth      , presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :weight     , presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :stock_level, presence: true, numericality: { only_integer: true, greater_than: -1 }
end
