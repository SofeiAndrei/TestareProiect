require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:adrian)
    @another_user = users(:andrei)
  end
  test 'micropost interface with image' do
    log_in_as @user
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_template 'static_pages/home'
    assert_select 'div#error-explanations'
    assert_select 'a[href=?]', '/?page=2' # Correct pagination link
    # Valid submission
    content = 'Hello, eu sunt content-ul'
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    assert assigns(:micropost).image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'button', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete links)
    get user_path(users(:andrei))
    assert_select 'button', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as @user
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    delete logout_path
    log_in_as @another_user
    get root_path
    assert_match '0 microposts', response.body
    @another_user.microposts.create!(content: 'New post')
    get root_path
    assert_match '1 micropost', response.body
  end

end