# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @post = Post.includes([:user]).search(params[:word])
    @word = params[:word]
  end
end
