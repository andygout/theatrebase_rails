module Associations::Theatre

  extend ActiveSupport::Concern

  included do
    has_many :productions

    belongs_to :creator,
      class_name: :User,
      foreign_key: :creator_id

    belongs_to :updater,
      class_name: :User,
      foreign_key: :updater_id
  end

end
