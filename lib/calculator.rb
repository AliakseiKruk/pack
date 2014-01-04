class Calculator
  def self.calculate(box, products)
    products.sort!{ |a,b| b['volume'] <=> a['volume'] }
    if products[0]['volume'] <= box
      boxes = []
      while products.size > 0
        current_box = []
        free_space = box
        to_delete = []
        products.each do |p|
          if ( quantity = Integer(free_space/p['volume']) ) > 0
            quantity = p['order'] if quantity > p['order']
            current_box.push({ 'id'=>p['id'], 'qnt'=>quantity })
            free_space -= quantity * p['volume']
            p['order'] -= quantity
            to_delete.push(p) if p['order'] == 0
          end
        end
        to_delete.each { |product| products.delete(product) }
        boxes.push({ 'box'=>current_box, 'full'=>Integer(Float(box - free_space)/box*100) }) if current_box.size > 0
      end
      return {'boxes'=>boxes}
    else
      return {'error' => 'Box is too small'}
    end
  end
end
