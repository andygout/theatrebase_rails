class Suspension < ActiveRecord::Base

  include Associations::Status
  include Validations::Status

  self.primary_key = :user_id

end
