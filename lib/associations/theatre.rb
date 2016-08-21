module Associations::Theatre

  extend ActiveSupport::Concern
  include BelongsToCreatorUpdater

  included do
    has_many :productions, dependent: :restrict_with_error
  end

end
