# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :group_comments, dependent: :destroy
  
  belongs_to :user
  
  validates :name, presence: true, length: { minimum: 2 }
  validates :introduction, presence: true, length: { maximum: 50 }
  attachment :group_image, destroy: false
end
