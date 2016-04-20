class SuperAdmin < ActiveRecord::Base

  include Validations::SuperAdmin

  self.primary_key = :user_id

  belongs_to :user

end
