# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.create!(
  [
    {email: 'test@test', gender: '女性', name: 'ピーチ', introduction: '任天堂ゲームが好きです！', password: 'password', profile_image: File.open("#{Rails.root}/db/fixtures/peach.png")},
    {email: 'test1@test', gender: '女性', name: 'さおり', introduction: 'アクションゲーム全般やります', password: 'password1', profile_image: File.open("#{Rails.root}/db/fixtures/megane.png")},
    {email: 'test2@test', gender: '女性', name: 'ホライゾン', introduction: 'FPSにハマってます！仲良くしてね！', password: 'password2', profile_image: File.open("#{Rails.root}/db/fixtures/blackhole.png")}
  ]
)

posts = Post.create!(
  [
    {title: 'マリオ64', body: '3Dマリオの元祖！絵の中に入ってワールド選択するワクワク感は今でも楽しい！BGMも楽しい♪', rate: '5.0', user_id: users[0].id },
    {title: 'ジャッジアイス',body: '敵を一掃できる爽快感は無双シリーズに近いものがあります。メインストーリーはもちろん、サイドストーリーも面白いです。', rate: '4.5', user_id: users[1].id },
    {title: 'Apex', body: 'ダイヤ帯に行けなくて泣いてます', rate: '3.0', user_id: users[2].id }
  ])
  
PostComment.create!(
  [
    {comment: '私も大好きです！5周はやりました！', post_id: posts[0].id, user_id: users[2].id },
    {comment: '難しいですよね。良ければ今度一緒にやりませんか', post_id: posts[2].id, user_id: users[1].id }
  ])