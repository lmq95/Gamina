require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'Homeを押すと、自分のユーザ詳細画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Usersを押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[2].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it 'postsを押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[3].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/posts'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link post.title, href: post_path(post)
        expect(page).to have_link other_post.title, href: post_path(other_post)
      end
      it '自分の投稿と他人の投稿のオピニオンが表示される' do
        expect(page).to have_content post.body
        expect(page).to have_content other_post.body
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
       it '自分のフォロー数にフォロー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followings_path(user)
      end
       it '自分のフォロワー数にフォロワー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followers_path(user)
      end
       it '新規投稿画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_post_path(user)
      end

 describe '新規投稿画面のテスト' do
    before do
      visit new_post_path
    end
      it 'タイトルフォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it 'タイトルフォームに値が入っていない' do
        expect(find_field('post[title]').text).to be_blank
      end
      it 'ジャンルフォームが表示される' do
        expect(page).to have_field 'post[ganre]'
      end
      it 'ジャンルフォームに値が入っていない' do
        expect(find_field('post[ganre]').text).to be_blank
      end
      it 'レビューフォームが表示される' do
        expect(page).to have_field 'post[rate]'
      end
      it 'レビューフォームに値が入っていない' do
        expect(find_field('post[rate]').text).to be_blank
      end
      it '本文フォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it '本文フォームに値が入っていない' do
        expect(find_field('post[body]').text).to be_blank
      end
      it 'Create Bookボタンが表示される' do
        expect(page).to have_button 'Create post'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'Create post' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button 'Create post'
        expect(current_path).to eq '/posts/' + post.last.id.to_s
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit book_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザ画像・名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿のopinionが表示される' do
        expect(page).to have_content post.body
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link 'Edit', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link 'Destroy', href: post_path(post)
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
       it '自分のフォロー数にフォロー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followings_path(user)
      end
       it '自分のフォロワー数にフォロワー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followers_path(user)
      end
       it '新規投稿画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_post_path(user)
      end
  

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link ''
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link ''
      end

      it '正しく削除される' do
        expect(Book.where(id: book.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/books'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_book_path(book)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it '「Editing Book」と表示される' do
        expect(page).to have_content 'edit.gif'
      end
      it 'title編集フォームが表示される' do
        expect(page).to have_field 'post[title]', with: post.title
      end
      it 'opinion編集フォームが表示される' do
        expect(page).to have_field 'post[body]', with: post.body
      end
      it 'Update Bookボタンが表示される' do
        expect(page).to have_button 'Update Book'
      end
      it 'Showリンクが表示される' do
        expect(page).to have_link 'Show', href: V_path(post)
      end

    context '編集成功のテスト' do
      before do
        @post_old_title = post.title
        @post_old_body = post.body
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 19)
        click_button 'Update Book'
      end

      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'bodyが正しく更新される' do
        expect(post.reload.body).not_to eq @post_old_body
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
        expect(page).to have_content 'Book detail'
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の画像が表示される: fallbackの画像がサイドバーの1つ＋一覧(2人)の2つの計3つ存在する' do
        expect(all('img').size).to eq(3)
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人のshowリンクがそれぞれ表示される' do
        expect(page).to have_link 'Show', href: user_path(user)
        expect(page).to have_link 'Show', href: user_path(other_user)
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
       it '自分のフォロー数にフォロー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followings_path(user)
      end
       it '自分のフォロワー数にフォロワー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followers_path(user)
      end
       it '新規投稿画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_post_path(user)
      end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい' do
        expect(page).to have_link post.title, href: post_path(post)
      end
      it '投稿一覧に自分の投稿のopinionが表示される' do
        expect(page).to have_content post.body
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.title
        expect(page).not_to have_content other_post.body
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
       it '自分のフォロー数にフォロー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followings_path(user)
      end
       it '自分のフォロワー数にフォロワー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followers_path(user)
      end
       it '新規投稿画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_post_path(user)
      end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'Update Userボタンが表示される' do
        expect(page).to have_button 'Update User'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button 'Update User'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end