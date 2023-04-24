require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin_user = users(:adrian)
    @another_user = users(:oana)
  end

  test 'includes pagination and delete buttons' do
    log_in_as(@admin_user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      next unless user.activated?
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin_user
        assert_select 'a[href=?]', user_path(user), text: "Delete"
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@another_user)
    end
  end

  test 'index as non-admin' do
    log_in_as(@another_user)
    get users_path
    assert_select 'form[action=delete]', text: "Delete", count: 0
  end
end
