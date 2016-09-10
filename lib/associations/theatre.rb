module Associations::Theatre

  extend ActiveSupport::Concern
  include BelongsToCreatorUpdater

  included do
    has_many :productions, dependent: :restrict_with_error

    belongs_to :sur_theatre, class_name: :Theatre, foreign_key: :sur_theatre_id

    has_many :sub_theatres, class_name: :Theatre, foreign_key: :sur_theatre_id, dependent: :restrict_with_error
  end

end
