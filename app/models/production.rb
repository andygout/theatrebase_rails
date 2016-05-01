class Production < ActiveRecord::Base

  include Validations::Production
  include Associations::Production
  include Shared::ParamsHelper
  include ActiveModel::Validations
  include Productions::ValidationsHelper

  before_validation :strip_whitespace

end
