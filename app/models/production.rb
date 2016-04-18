class Production < ActiveRecord::Base

  include Validations::Production
  include ActiveModel::Validations
  include Productions::ValidationsHelper

  before_validation :strip_whitespace

  belongs_to :creator,
    class_name: :User,
    foreign_key: :creator_id

  belongs_to :updater,
    class_name: :User,
    foreign_key: :updater_id

  private

    def strip_whitespace
      self.attributes.keys.map { |k| self[k] = self[k].strip if self[k].class == String }
    end

end
