module BelongsToCreatorUpdater

  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: :User, foreign_key: :creator_id
    validates_presence_of :creator

    belongs_to :updater, class_name: :User, foreign_key: :updater_id
    validates_presence_of :updater
  end

end
