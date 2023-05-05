class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: {maximum: 140, minimum: 5}
  validates :title, presence: true
  validates :user_id, presence: true
  validates :image, content_type: { in: ['image/jpeg', 'image/gif', 'image/png'],
                                    message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes,
                            message: 'must be less than 5MB' }
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  def post_length_comparison(avg_content_length)
    answer = []                                      #1
    #2
    content_length = content.length                  #3
    if content_length < 20                           #4
      answer.append("Short content")                 #5
    elsif content_length < 50                        #6
      answer.append("Medium content")                #7
    else                                             #8
      answer.append("Long content")                  #9
    end                                              #10
    #11
    if content_length > avg_content_length           #12
      answer.append("Larger than average content")   #13
    else                                             #14
      answer.append("Smaller than average content")  #15
    end                                              #16
    #17
    return answer                                    #18
  end

  def mutant1(avg_content_length)
    answer = []

    content_length = content.length
    if content_length <= 20
      answer.append("Short content")
    elsif content_length <= 50
      answer.append("Medium content")
    else
      answer.append("Long content")
    end

    if content_length > avg_content_length
      answer.append("Larger than average content")
    else
      answer.append("Smaller than average content")
    end

    return answer
  end

  def mutant2(avg_content_length)
    answer = []

    content_length = content.length
    if content_length > 20
      answer.append("Short content")
    elsif content_length > 50
      answer.append("Medium content")
    else
      answer.append("Long content")
    end

    if content_length > avg_content_length
      answer.append("Larger than average content")
    else
      answer.append("Smaller than average content")
    end

    return answer
  end

  def mutant3(avg_content_length)
    answer = []

    content_length = content.length
    if content_length < 20
      answer.append("Short content")
    elsif content_length < 50
      answer.append("Medium content")
    else
      answer.append("Long content")
    end

    if content_length >= avg_content_length
      answer.append("Larger than average content")
    else
      answer.append("Smaller than average content")
    end

    return answer
  end

  def mutant4(avg_content_length)
    answer = []

    content_length = content.length
    if content_length < 20
      answer.append("Short content")
    elsif content_length < 50
      answer<<"Medium content"
    else
      answer<<"Long content"
    end

    if content_length > avg_content_length
      answer.append("Larger than average content")
    else
      answer.append("Smaller than average content")
    end

    return answer
  end

  def mutant5(avg_content_length)
    answer = []

    content_length = content.size
    if content_length < 20
      answer.append("Short content")
    elsif content_length < 50
      answer.append("Medium content")
    else
      answer.append("Long content")
    end

    if content_length > avg_content_length
      answer.append("Larger than average content")
    else
      answer.append("Smaller than average content")
    end

    return answer
  end

  def mutant6(avg_content_length)
    answer = []

    content_length = content.length
    if content_length < 20
      answer.append("Short content")
    elsif content_length < 50
      answer.append("Medium content")
    else
      answer.append("Long content")
    end

    if content_length < avg_content_length
      answer.append("Larger than average content")
    else
      answer.append("Smaller than average content")
    end

    return answer
  end
end
