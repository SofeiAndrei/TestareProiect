require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:adrian)
    @micropost = @user.microposts.build(content: 'Lorem Ipsum', title: 'Title')
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
  test 'equivalence partitioning' do
    # functional testing
    #
    # micropost.length
    #   1)micropost.length <20
    #   2)micropost.length = 20..49
    #   3)micropost.length >=50
    #
    # average
    #   avg > micropost.length
    #   avg < micropost.length
    #
    #1)
    assert_equal ["Short content", "Larger than average content"], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(10)
    assert_equal ["Short content", "Smaller than average content"], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(30)
    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(30)
    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 40, title: 'Title', user_id: 1).post_length_comparison(30)
    assert_equal ["Long content", "Smaller than average content"], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(70)
    assert_equal ["Long content", "Larger than average content"], Micropost.new(content: 'a' * 80, title: 'Title', user_id: 1).post_length_comparison(70)
  end
  test 'boundary analysis' do
    # boundary analysis
    # micropost.length1 = 19
    # micropost.length2 = 20,49
    # micropost.length3 = 50

    # average
    # avg = micropost.length
    # avg = micropost.length - 1
    assert_equal ["Short content", "Smaller than average content"], Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).post_length_comparison(19)
    assert_equal ["Short content", "Larger than average content"], Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).post_length_comparison(18)

    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).post_length_comparison(20)
    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).post_length_comparison(19)

    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).post_length_comparison(49)
    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).post_length_comparison(48)

    assert_equal ["Long content", "Smaller than average content"], Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).post_length_comparison(50)
    assert_equal ["Long content", "Larger than average content"], Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).post_length_comparison(49)

  end
  test 'category partitioning' do
    # category partitioning
    #
    # micropost.length
    #
    # micropost.length <19
    # micropost.length = 19
    # micropost.length = 20
    # micropost.length = 21..48
    # micropost.length = 49
    # micropost.length = 50
    # micropost.length > 50

    #average
    # avg < micropost.length - 1
    # avg = micropost.length - 1
    # avg = micropost.length
    # avg > micropost.length
    assert_equal ["Short content", "Larger than average content"], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(13)
    assert_equal ["Short content", "Larger than average content"], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(14)
    assert_equal ["Short content", "Smaller than average content"], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(15)
    assert_equal ["Short content", "Smaller than average content"], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(16)

    assert_equal ["Short content", "Larger than average content"], Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).post_length_comparison(17)
    assert_equal ["Short content", "Larger than average content"], Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).post_length_comparison(18)
    assert_equal ["Short content", "Smaller than average content"], Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).post_length_comparison(19)
    assert_equal ["Short content", "Smaller than average content"], Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).post_length_comparison(20)

    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).post_length_comparison(18)
    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).post_length_comparison(19)
    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).post_length_comparison(20)
    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).post_length_comparison(21)

    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(23)
    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(24)
    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(25)
    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(26)

    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).post_length_comparison(47)
    assert_equal ["Medium content", "Larger than average content"], Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).post_length_comparison(48)
    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).post_length_comparison(49)
    assert_equal ["Medium content", "Smaller than average content"], Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).post_length_comparison(50)

    assert_equal ["Long content", "Larger than average content"], Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).post_length_comparison(48)
    assert_equal ["Long content", "Larger than average content"], Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).post_length_comparison(49)
    assert_equal ["Long content", "Smaller than average content"], Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).post_length_comparison(50)
    assert_equal ["Long content", "Smaller than average content"], Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).post_length_comparison(51)

    assert_equal ["Long content", "Larger than average content"], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(58)
    assert_equal ["Long content", "Larger than average content"], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(59)
    assert_equal ["Long content", "Smaller than average content"], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(60)
    assert_equal ["Long content", "Smaller than average content"], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(61)

  end

  test 'statement coverage' do
    assert_equal ['Short content', 'Smaller than average content'], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(16)
    assert_equal ['Medium content', 'Smaller than average content'], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(26)
    assert_equal ['Long content', 'Larger than average content'], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(58)
  end

  test 'branch coverage' do
    assert_equal ['Short content', 'Smaller than average content'], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(16)
    assert_equal ['Medium content', 'Smaller than average content'], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(26)
    assert_equal ['Long content', 'Larger than average content'], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(58)
  end

  test 'condition coverage' do
    assert_equal ['Short content', 'Smaller than average content'], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(16)
    assert_equal ['Medium content', 'Smaller than average content'], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(26)
    assert_equal ['Long content', 'Larger than average content'], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(58)
  end

  test 'decision coverage' do
    assert_equal ['Short content', 'Smaller than average content'], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(16)
    assert_equal ['Short content', 'Larger than average content'], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(14)
    assert_equal ['Medium content', 'Smaller than average content'], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(26)
    assert_equal ['Medium content', 'Larger than average content'], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(24)
    assert_equal ['Long content', 'Smaller than average content'], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(61)
    assert_equal ['Long content', 'Larger than average content'], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(59)
  end

  test 'path coverage' do
    assert_equal ['Short content', 'Smaller than average content'], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(16)
    assert_equal ['Short content', 'Larger than average content'], Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).post_length_comparison(14)
    assert_equal ['Medium content', 'Smaller than average content'], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(26)
    assert_equal ['Medium content', 'Larger than average content'], Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).post_length_comparison(24)
    assert_equal ['Long content', 'Smaller than average content'], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(61)
    assert_equal ['Long content', 'Larger than average content'], Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).post_length_comparison(59)
  end

  test 'mutation testing' do
    mutant1 = []

    mutant1.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant1(13))
    mutant1.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant1(14))
    mutant1.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant1(15))
    mutant1.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant1(16))

    mutant1.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant1(17))
    mutant1.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant1(18))
    mutant1.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant1(19))
    mutant1.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant1(20))

    mutant1.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant1(18))
    mutant1.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant1(19))
    mutant1.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant1(20))
    mutant1.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant1(21))

    mutant1.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant1(23))
    mutant1.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant1(24))
    mutant1.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant1(25))
    mutant1.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant1(26))

    mutant1.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant1(47))
    mutant1.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant1(48))
    mutant1.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant1(49))
    mutant1.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant1(50))

    mutant1.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant1(48))
    mutant1.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant1(49))
    mutant1.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant1(50))
    mutant1.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant1(51))

    mutant1.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant1(58))
    mutant1.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant1(59))
    mutant1.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant1(60))
    mutant1.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant1(61))

    puts "mutant1",mutant1

    mutant2 = []

    mutant2.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant2(13))
    mutant2.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant2(14))
    mutant2.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant2(15))
    mutant2.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant2(16))

    mutant2.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant2(17))
    mutant2.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant2(18))
    mutant2.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant2(19))
    mutant2.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant2(20))

    mutant2.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant2(18))
    mutant2.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant2(19))
    mutant2.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant2(20))
    mutant2.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant2(21))

    mutant2.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant2(23))
    mutant2.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant2(24))
    mutant2.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant2(25))
    mutant2.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant2(26))

    mutant2.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant2(47))
    mutant2.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant2(48))
    mutant2.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant2(49))
    mutant2.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant2(50))

    mutant2.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant2(48))
    mutant2.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant2(49))
    mutant2.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant2(50))
    mutant2.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant2(51))

    mutant2.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant2(58))
    mutant2.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant2(59))
    mutant2.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant2(60))
    mutant2.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant2(61))

    puts "mutant2", mutant2

    mutant3 = []

    mutant3.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant3(13))
    mutant3.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant3(14))
    mutant3.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant3(15))
    mutant3.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant3(16))

    mutant3.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant3(17))
    mutant3.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant3(18))
    mutant3.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant3(19))
    mutant3.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant3(20))

    mutant3.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant3(18))
    mutant3.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant3(19))
    mutant3.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant3(20))
    mutant3.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant3(21))

    mutant3.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant3(23))
    mutant3.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant3(24))
    mutant3.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant3(25))
    mutant3.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant3(26))

    mutant3.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant3(47))
    mutant3.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant3(48))
    mutant3.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant3(49))
    mutant3.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant3(50))

    mutant3.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant3(48))
    mutant3.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant3(49))
    mutant3.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant3(50))
    mutant3.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant3(51))

    mutant3.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant3(58))
    mutant3.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant3(59))
    mutant3.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant3(60))
    mutant3.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant3(61))

    puts "mutant3", mutant3

    mutant4 = []

    mutant4.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant4(13))
    mutant4.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant4(14))
    mutant4.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant4(15))
    mutant4.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant4(16))

    mutant4.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant4(17))
    mutant4.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant4(18))
    mutant4.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant4(19))
    mutant4.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant4(20))

    mutant4.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant4(18))
    mutant4.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant4(19))
    mutant4.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant4(20))
    mutant4.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant4(21))

    mutant4.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant4(23))
    mutant4.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant4(24))
    mutant4.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant4(25))
    mutant4.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant4(26))

    mutant4.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant4(47))
    mutant4.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant4(48))
    mutant4.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant4(49))
    mutant4.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant4(50))

    mutant4.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant4(48))
    mutant4.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant4(49))
    mutant4.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant4(50))
    mutant4.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant4(51))

    mutant4.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant4(58))
    mutant4.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant4(59))
    mutant4.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant4(60))
    mutant4.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant4(61))

    #puts "mutant4", mutant4

    mutant5 = []

    mutant5.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant5(13))
    mutant5.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant5(14))
    mutant5.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant5(15))
    mutant5.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant5(16))

    mutant5.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant5(17))
    mutant5.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant5(18))
    mutant5.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant5(19))
    mutant5.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant5(20))

    mutant5.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant5(18))
    mutant5.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant5(19))
    mutant5.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant5(20))
    mutant5.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant5(21))

    mutant5.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant5(23))
    mutant5.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant5(24))
    mutant5.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant5(25))
    mutant5.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant5(26))

    mutant5.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant5(47))
    mutant5.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant5(48))
    mutant5.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant5(49))
    mutant5.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant5(50))

    mutant5.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant5(48))
    mutant5.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant5(49))
    mutant5.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant5(50))
    mutant5.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant5(51))

    mutant5.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant5(58))
    mutant5.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant5(59))
    mutant5.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant5(60))
    mutant5.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant5(61))

    #puts "mutant5", mutant5

    mutant6 = []

    mutant6.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant6(13))
    mutant6.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant6(14))
    mutant6.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant6(15))
    mutant6.push( Micropost.new(content: 'a' * 15, title: 'Title', user_id: 1).mutant6(16))

    mutant6.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant6(17))
    mutant6.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant6(18))
    mutant6.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant6(19))
    mutant6.push( Micropost.new(content: 'a' * 19, title: 'Title', user_id: 1).mutant6(20))

    mutant6.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant6(18))
    mutant6.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant6(19))
    mutant6.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant6(20))
    mutant6.push( Micropost.new(content: 'a' * 20, title: 'Title', user_id: 1).mutant6(21))

    mutant6.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant6(23))
    mutant6.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant6(24))
    mutant6.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant6(25))
    mutant6.push( Micropost.new(content: 'a' * 25, title: 'Title', user_id: 1).mutant6(26))

    mutant6.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant6(47))
    mutant6.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant6(48))
    mutant6.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant6(49))
    mutant6.push( Micropost.new(content: 'a' * 49, title: 'Title', user_id: 1).mutant6(50))

    mutant6.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant6(48))
    mutant6.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant6(49))
    mutant6.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant6(50))
    mutant6.push( Micropost.new(content: 'a' * 50, title: 'Title', user_id: 1).mutant6(51))

    mutant6.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant6(58))
    mutant6.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant6(59))
    mutant6.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant6(60))
    mutant6.push( Micropost.new(content: 'a' * 60, title: 'Title', user_id: 1).mutant6(61))

    #puts "mutant6", mutant6
  end


end
