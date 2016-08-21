module Associations::Status

  extend ActiveSupport::Concern
  include BelongsToUser

  included do
    belongs_to :assignor, class_name: :User, foreign_key: :assignor_id
  end

end
