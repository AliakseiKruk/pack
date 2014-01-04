require File.expand_path('../../../lib/calculator.rb',__FILE__)

class PacksController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_action :check_params, only: [:pack]

  def index
    render 'index'
  end

  def pack
    result = {'boxes' => []}
    if @pack.box.volume > 0 and @pack.products.size > 0
      result =  Calculator.calculate(@pack.box.volume, @pack.products)
    end
    render :json => result
  end

  private

  def check_params
    @pack = Packs.new(params['todo'])
    render :json => {'error' => @pack.errors.messages} unless @pack.valid?
  end
end
