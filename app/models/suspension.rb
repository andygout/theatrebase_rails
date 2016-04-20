class Suspension < ActiveRecord::Base

  include Validations::Status

  self.primary_key = :user_id

  belongs_to :user

  belongs_to :assignor,
    class_name: :User,
    foreign_key: :assignor_id

end
