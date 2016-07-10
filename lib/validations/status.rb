module Validations::Status

  extend ActiveSupport::Concern

  included do
    validates :user,
      presence: true

    validates :assignor,
      presence: true
  end

end
