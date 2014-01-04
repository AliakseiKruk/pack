module ApplicationHelper
  def index
    @items = entity.all()
    render :json => @items
  end

  def create
    @item = entity.new(entity_params)
    save_and_return_id()
  end

  def update
    begin
      @item = entity.find(params[entity.name.downcase].delete('id').to_i)
      entity_params.each do |key, value|
        @item.send("#{key}=".to_sym, value)
      end
      save_and_return_id()
    rescue
      render :json => {'error' => {'id'=>["#{entity.name} does not exist"]}}
    end
  end

  def destroy
    begin
      @item = entity.find(params['id'].to_i)
      destroy_and_return_id()
    rescue
      render :json => {'error' => {'id'=>["#{entity.name} does not exist"]}}
    end
  end

  def  save_and_return_id
    do_and_return_id do
      @item.save()
      @item.reload()
      @id = @item.id
    end
  end

  def  destroy_and_return_id
    do_and_return_id do
      @id = @item.id
      @item.destroy
    end
  end

  def do_and_return_id(&block)
    if @item.valid?
      begin
        block.call()
        render :json => {'id' => @id}
      rescue Exception => e
        render :json => {'error' => e.class.name}
      end
    else
      render :json => {'error' => @item.errors.messages}
    end
  end
end
