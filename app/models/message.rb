# frozen_string_literal: true

class Message < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user
  belongs_to :room

  validates :body, presence: true, length: { maximum: 140 }
end
