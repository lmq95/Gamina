class UsersController < ApplicationController
  
  def index
  end
  
  def show
  end
  
  def edit
    @model_class_name = ModelClassName.find(params[:id])
  end
  
  def update

  end
  
  
end
