require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:adrian)
    @another_user = users(:oana)
    @activated_user = users(:andrei)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App'
  end

  test 'should redirect edit to login' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: 'New Name',
                                              email: 'newemail@yahoo.com',
                                              password: 'delungime8nou',
                                              password_confirmation: 'delungime8nou' } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as another user' do
    log_in_as(@activated_user)
    get edit_user_path(@another_user)
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as another activated user' do
    log_in_as(@activated_user)
    patch user_path(@user), params: { user: { name: 'New Name',
                                              email: 'newemail@yahoo.com',
                                              password: 'delungime8nou',
                                              password_confirmation: 'delungime8nou' } }
    assert_redirected_to root_url
  end

  test 'should be redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should not be able to give admin priviledges through web' do
    log_in_as(@another_user)
    assert_not @another_user.admin?
    patch user_path(@another_user), params: { user: { password: 'passoflengthmin8',
                                              password_confirmation: 'passoflengthmin8',
                                              admin: true} }
    assert_not @another_user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@another_user)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not admin' do
    log_in_as(@activated_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  test 'should be able to delete users as admin' do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@another_user)
    end
  end

  test 'should redirect to home when showing not activated user' do
    assert_not @another_user.activated?
    get user_path(@another_user)
    assert_redirected_to root_url
  end

  test 'should redirect following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test 'should redirect followers when not logged in' do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end