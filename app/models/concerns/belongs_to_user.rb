module BelongsToUser

  extend ActiveSupport::Concern

  included do
    belongs_to :user
    validates_presence_of :user

    belongs_to :assignor, class_name: :User, foreign_key: :assignor_id
  end

end
