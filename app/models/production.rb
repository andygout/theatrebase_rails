class Production < ActiveRecord::Base

  include Productions::ValidationsHelper
  include Shared::ParamsHelper
  include Associations::Production
  include Validations::Production

  before_validation :strip_whitespace

end
