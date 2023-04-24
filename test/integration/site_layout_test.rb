require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:adrian)
  end
  # test "the truth" do
  #   assert true
  # end
  test 'layout links not logged in' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', helf_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path
    get contact_path
    assert_select "title", full_title("Contact")
  end
  test 'layout links logged in' do
    log_in_as(@user)
    assert_redirected_to @user
    follow_redirect!
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', helf_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', user_path
    assert_select 'a[href=?]', edit_user_path
    assert_select 'a[href=?]', logout_path, count: 1
  end
  test 'full title helper' do
    assert_equal full_title, "Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Sign Up"), "Sign Up | Ruby on Rails Tutorial Sample App"
  end
end
