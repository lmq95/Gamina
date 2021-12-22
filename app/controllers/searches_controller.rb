class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @post = Post.search(params[:word])
    @word = params[:word]
  end
end
