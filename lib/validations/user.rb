module Validations::User

  extend ActiveSupport::Concern
  include Shared::ConstantsHelper

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  included do
    validates :name,
      presence: true,
      length: { maximum: TEXT_MAX_LENGTH }

    validates :email,
      presence: true,
      length: { maximum: TEXT_MAX_LENGTH },
      format: { with: VALID_EMAIL_REGEX },
      uniqueness: { case_sensitive: false }

    has_secure_password
    validates :password,
      presence: true,
      length: { minimum: PASSWORD_MIN_LENGTH },
      allow_nil: true
  end

end
