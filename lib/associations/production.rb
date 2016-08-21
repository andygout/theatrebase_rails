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
  end

end
