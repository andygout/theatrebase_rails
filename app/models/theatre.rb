class Theatre < ActiveRecord::Base

  include Shared::ParamsHelper
  include Associations::Theatre
  include Validations::Theatre

  before_validation :strip_whitespace

end
