class ListItemsController < ApplicationController
    before_action :authorize_access_request!
    before_action :set_list_item, only: [:show, :update, :destroy]
  
    def index
      @todo = Todo.find(params[:todo_id])  
      @list_items = @todo.list_items.all
      render json: @list_items
    end

    # GET /list_items/1
    def show
      render json: @list_item
    end
  
    # POST /list_items
    def create
      @todo = Todo.find(params[:todo_id]) 
      puts list_item_params
      @list_item = @todo.list_items.build(list_item_params)
      @list_item.save!
      render json: @list_item, status: :created
    end
  
    # PATCH/PUT /list_items/1
    def update
      @list_item.update!(list_item_params)
      render json: @list_item
    end
  
    # DELETE /list_items/1
    def destroy
      @list_item.destroy
    end
  
    private
  
    def set_list_item
      @todo = Todo.find(params[:todo_id])
      @list_item = @todo.item_lists.find(params[:id])
    end
  
    def list_item_params
      params.require(:list_item).permit(:name, :status, :url_base, :url_endpoint, :code, :requests, :thrown_errors)
    end
  end
  