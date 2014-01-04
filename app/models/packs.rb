class Packs
  class Errors
    def initialize
      @messages = {}
    end

    def push(key, message)
      @messages[key] = [] unless @messages.has_key?(key)
      @messages[key] = message
    end

    def size
      @messages.size
    end

    def messages
      @messages
    end
  end

  def initialize(params)
    @params = params
  end

  def errors
    @errors
  end

  def box
    @box
  end

  def products
    @products
  end

  def valid?
    @errors = Errors.new
    if valid_data_structure?
      @box = @params.shift
      validate_box()
      @products = []
      i = -1
      @params.each do |p|
        i += 1
        if valid_node?(p, i)
          if valid_node_key?('id', p, i) && valid_node_key?('order', p, i)
            push_to_products(p)
          end
        end
      end
    end
    @errors.size > 0 ? false : true
  end

  private

  def valid_data_structure?
    if @params && @params.class == Array && @params.size > 1
      return true
    else
      @errors.push('pack', "Unexpected data structure: #{@params.inspect}")
      return false
    end
  end

  def validate_box
    if @box.to_s !~ /^[0-9]+$/
      @errors.push('box', 'Box is not number')
    else
      @box = Box.find(@box.to_i)
    end
  end

  def valid_node?(p, i)
    if p.respond_to?('keys')
      return true
    else
      @errors.push("product[#{i}]", "Product node is #{p.class.name} instead of Hash")
      return false
    end
  end

  def valid_node_key?(key, p, i)
    if p.has_key?(key)
      if p[key].to_s !~ /^[0-9]+$/
        @errors.push("product[#{i}][#{key}]", "#{key} is #{p[key].class.name} instead of Fixnum")
      else
        p[key] = p[key].to_i
        return true
      end
    else
      @errors.push("product[#{i}]", "product node does not contain ID key: #{p.inspect}")
    end
    return false
  end

  def push_to_products(p)
    if p['order'] > 0
      product = Product.find(p['id'])
      if p['order'] <= product.stock_level
        volume = product.width * product.height * product.depth
        @products.push({'id'=>p['id'], 'order'=>p['order'], 'volume'=>volume }) if volume > 0
      end
    end
  end
end
