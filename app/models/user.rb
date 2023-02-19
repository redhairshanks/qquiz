class User < ApplicationRecord
  has_secure_password
  validates :name, format: { with: /\A[a-zA-Z]+\z/, message: "Only allows alphabets" }, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :b_save

  def self.find_by_session(session_id)
    Utils.cache_read(key_session_id(session_id))
  end

  def self.create_session(user, expiry = 3.hours)
    session_id = SecureRandom.hex(24)
    Utils.cache(key_session_id(session_id), {user: user}, expiry)
    session_id
  end

  def self.key_session_id(session_id)
    "user::session::#{session_id}"
  end

  private

  def b_save
    self.email = self.email.downcase
  end

end