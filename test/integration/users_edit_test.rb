require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:adrian)
  end
  # test "the truth" do
  #   assert true
  # end
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'user@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div.alert' do |alerta|
      assert_equal 'The form contains 5 errors', alerta.text.strip # am pus strip ca sa imi stearga spatiile de la inceput si de la final, un fel de trim
    end
  end

  test 'sucessful edit' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)

    log_in_as(@user)
    assert_redirected_to user_url(@user)
    # primele 3 linii sunt test de "friendly forwarding,
    # adica daca userul alex vrea sa isi editeze profilul de exemplut,
    # dar nu e logged in, Atunci o sa il duca la pagina de login
    # si dupa ce se logheaza sa il trimita direct unde voia sa mearga
    #
    # Daca nu voiam asta puteam sa scriem pur si simplu
    # log_in_as(@user)
    # get edit_user_path(@user)
    # assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: 'New Name',
                                              email: 'newemail@yahoo.com',
                                              password: 'delungime8nou',
                                              password_confirmation: 'delungime8nou' } }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    @user.reload
    assert_equal 'New Name', @user.name
    assert_equal 'newemail@yahoo.com', @user.email
  end

end