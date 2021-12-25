# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 投稿機能
  has_many :posts, dependent: :destroy
  # コメント機能
  has_many :post_comments, dependent: :destroy
  # いいね機能
  has_many :favorites, dependent: :destroy

  # グループ機能
  has_many :groups, through: :group_users
  has_many :group_users

  # フォロー・フォロワー機能
  # 自分がフォローする（与フォロー側）
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  # 与フォロー関係を通じて参照する
  has_many :followings, through: :relationships, source: :followed
  # 自分はフォローされる〈被フォロー側）
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  # 被フォローを通じて参照
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # DM機能
  has_many :entries, dependent: :destroy
  has_many :messeges, dependent: :destroy

  # 通知機能
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  enum gender: { 女性: 0, 男性: 1 }

  attachment :profile_image

  # フォロー
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # フォロー通知作成メソッド
  def create_notification_follow!(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # バリデーション
  validates :name, presence: { message: 'は１文字以上入力してください。' }
  validates :gender, inclusion: { in: %w(女性), message: 'は登録できません' }
end
