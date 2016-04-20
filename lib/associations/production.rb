module Associations::Production
  extend ActiveSupport::Concern

  included do
    belongs_to :creator,
      class_name: :User,
      foreign_key: :creator_id

    belongs_to :updater,
      class_name: :User,
      foreign_key: :updater_id
  end
end
