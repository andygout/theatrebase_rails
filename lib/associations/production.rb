module Associations::Production

  extend ActiveSupport::Concern
  include BelongsToCreatorUpdater

  included do
    belongs_to :theatre
    validates_presence_of :theatre
    accepts_nested_attributes_for :theatre

    def theatre_attributes=(attributes)
      self.theatre = Theatre.find_by_url(attributes[:url])
      attributes.merge!(self.theatre.attributes) if self.theatre
      assign_nested_attributes_for_one_to_one_association(:theatre, attributes)
    end

    has_one :sur_theatre, through: :theatre, source: :sur_theatre
    accepts_nested_attributes_for :sur_theatre

    def sur_theatre_attributes=(attributes)
      self.sur_theatre = Theatre.find_by_url(attributes[:url])
      attributes.merge!(self.sur_theatre.attributes) if self.sur_theatre
      assign_nested_attributes_for_one_to_one_association(:sur_theatre, attributes)
    end
  end

end
