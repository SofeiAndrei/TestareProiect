require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
  # test "the truth" do
  #   assert true
  # end
  test 'invalid signup information' do
    # verificam daca am introduce un user gresit daca numarul de entry-uri din User e la fel
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new' # am inclus ca in caz ca o submisie failed re-renders actiunea new
    assert_select 'div#error-explanations'
    assert_select 'div.field_with_errors'

  end

  test 'valid submissions with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Valid',
                                         email: 'user@valid.com',
                                         password: 'passoflengthmin8',
                                         password_confirmation: 'passoflengthmin8',
                                         activated: false } }
    end  # verifica daca la introducerea unui user valid diferenta este exact 1 la User.count

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)

    follow_redirect! # asta aranjeaza sa urmareasca redirectionarea la root
    assert_template 'static_pages/home' # ii spune ca ar trebui sa te redirectioneze la actiunea de home
    assert_not flash.empty? # verifica daca flash-ul nu e gol

    assert_not user.activated?
    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong@email')
    assert_not is_logged_in?
    # Valid token and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end