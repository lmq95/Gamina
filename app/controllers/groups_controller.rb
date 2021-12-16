class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
       redirect_to groups_path
    else
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
   if @group.update(group_params)
      redirect_to groups_path
   else
     render 'edit'
   end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

end
