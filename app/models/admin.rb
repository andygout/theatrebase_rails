class Admin < ActiveRecord::Base

  include Validations::Status
  include Associations::Status

  self.primary_key = :user_id

end
