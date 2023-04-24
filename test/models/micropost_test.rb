require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:adrian)
    @micropost = @user.microposts.build(content: 'Lorem Ipsum')
    # cu build doar creezi, nu se si salveaza in DB
    # cu create se si salveaza
    # E echivalent cu:
    # @micropost = Micropost.new(content: 'Lorem Ipsum', user_id: @user.id)

  end
  test 'should be valid' do
    assert @micropost.valid?
  end
  test 'user_id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  test 'content should be preset' do
    @micropost.content = nil
    assert_not @micropost.valid?
  end
  test 'content should have minimum length of 5' do
    @micropost.content = 'a' * 4
    assert_not @micropost.valid?
  end
  test 'content should have maximum length of 140' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end
  test 'order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end