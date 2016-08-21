module Associations::Production

  extend ActiveSupport::Concern

  included do
    belongs_to :theatre

    validates_presence_of :theatre

    accepts_nested_attributes_for :theatre

    def theatre_attributes=(attributes)
      self.theatre = Theatre.find_by_url(attributes[:url])
      attributes.merge!(self.theatre.attributes) if self.theatre
      assign_nested_attributes_for_one_to_one_association(:theatre, attributes)
    end

    belongs_to :creator, class_name: :User, foreign_key: :creator_id

    belongs_to :updater, class_name: :User, foreign_key: :updater_id
  end

end
