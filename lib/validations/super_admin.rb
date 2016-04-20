module Validations::SuperAdmin
  extend ActiveSupport::Concern

  included do
    validates :user,
      presence: true
  end
end
