class ProductsController < ApplicationController
  include ApplicationHelper
  skip_before_filter :verify_authenticity_token

  def entity
    Product
  end

  def entity_params
    params.require(:product).permit(:name, :width, :height, :depth, :weight, :stock_level)
  end
end
