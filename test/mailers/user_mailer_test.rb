require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:oana)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'Account activation', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['andrei.sofei@takeofflabs.com'], mail.from
    assert_match user.name, mail.body.encoded # sa fie numele userului in body
    assert_match user.activation_token, mail.body.encoded # sa fie token-ul in body(adica in url-ul de la link-ul de activare)
    assert_match CGI.escape(user.email), mail.body.encoded # sa fie prezent link-ul de activare
  end

  test 'password_resets' do
    user = users(:andrei)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'Password reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['andrei.sofei@takeofflabs.com'], mail.from
    assert_match user.reset_token, mail.body.encoded # sa fie token-ul in body(adica in url-ul de la link-ul de activare)
    assert_match CGI.escape(user.email), mail.body.encoded # sa fie prezent link-ul de activare
  end

end