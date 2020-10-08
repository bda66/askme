# frozen_string_literal: true

require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest.new('SHA256')
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_USERNAME_REGEX = /\A[0-9a-zA-Z_]*\z/.freeze
  VALID_BACKGROUNDCOLOR_REGEX = /\A[#0-9a-fA-F]{7,7}\z/.freeze

  has_many :questions

  validates :username, presence: true, uniqueness: true, length: { maximum: 40 }, format: { with: VALID_USERNAME_REGEX }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :background_color, format: { with: VALID_BACKGROUNDCOLOR_REGEX }, on: :update

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password
  before_validation :username_downcase

  def encrypt_password
    return unless password.present?

    self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
    self.password_hash = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack1('H*')
  end

  def self.authenticate(email, password)
    user = find_by(email: email)
    return nil unless user.present?

    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )
    return user if user.password_hash == hashed_password

    nil
  end

  def username_downcase
    username.downcase!
  end
end
