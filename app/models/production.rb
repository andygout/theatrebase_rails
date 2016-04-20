class Production < ActiveRecord::Base

  include Validations::Production
  include Associations::Production
  include ActiveModel::Validations
  include Productions::ValidationsHelper

  before_validation :strip_whitespace

  private

    def strip_whitespace
      self.attributes.keys.map { |k| self[k] = self[k].strip if self[k].class == String }
    end

end
