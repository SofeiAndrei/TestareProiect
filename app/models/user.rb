class User < ApplicationRecord
  has_many :microposts, dependent: :destroy # if you delete the user, you also delete the microposts
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed # the source explicitly tells that the source of following array is the set of followed ids
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token  # adauga remember_token si activation_token ca atribut, nu il pune in DB

  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  # echivalent cu before_save {self.email.downcase!}, ! iti si modifica variabila
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]\d]+)*\.[a-z]+\z/i
  validates :name, presence: true,
                   length: { minimum: 5, maximum: 50 }
  validates :email, presence: true,
                    uniqueness: true,
                    length: { minimum: 10, maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX }

  has_secure_password   # include functionalitatea pentru a avea o parola cu hash
  validates :password, presence: true,
                       length: { minimum: 8 }

  # Returns the hash digest for a given string, we need it to calculate the hash for a string to test for the successfulness of the login action
  # <=> User.digest(string)
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Creates a random token
  # <=> User.new_token
  def self.new_token
    SecureRandom.urlsafe_base64  # string de 22 de caractere cu a-z, A-z, 0-9, - si _
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token when passed to the hash function returns the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") # e echivalent cu a apela mai jos self.remember_digest sau self.activation_digest, depinde ce string e attribute-ul
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    self.update_columns(activated: true, activated_at: Time.zone.now)
    # echivalent cu
    # self.update_attribute(:activated, true)
    # self.update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end

  def feed
    # Asta este ineficient daca ai foarte multi followeri de exemply
    # Micropost.where('user_id IN (?) OR user_id = ?', following_ids, id)
    #
    # Folosind subselect:
    following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                    user_id: id).includes(:user, image_attachment: :blob)
    # SAU si nu mai faceai following_ids ca fiind SQL Query
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                 following_ids: following_ids, user_id: id)
  end

  def follow(another_user)
    self.following << another_user
  end

  def unfollow(another_user)
    self.following.delete(another_user)
  end

  def following?(another_user)
    return self.following.include?(another_user)
  end
  private

  def create_activation_digest
    # Creates the activation digest and token
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token)

    # e ca functia de remember
    # nu mai e nevoie de update_attribute pentru ca fiind apelata cu before_create,
    # o sa fie folosita asta doar la crearea unui user
  end

end
