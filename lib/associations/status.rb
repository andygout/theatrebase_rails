module Associations::Status

  extend ActiveSupport::Concern

  included do
    belongs_to :user

    belongs_to :assignor,
      class_name: :User,
      foreign_key: :assignor_id
  end

end
