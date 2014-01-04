class BoxesController < ApplicationController
  include ApplicationHelper
  skip_before_filter :verify_authenticity_token

  def entity
    Box
  end

  def entity_params
    params.require(:box).permit(:name, :volume)
  end
end
