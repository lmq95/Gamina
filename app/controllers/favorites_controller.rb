class FavoritesController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(user_id: current_user.id)
    favorite.save
    @post.create_notification_favorite!(current_user)
    redirect_to request.referer
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    redirect_to request.referer
  end
end
