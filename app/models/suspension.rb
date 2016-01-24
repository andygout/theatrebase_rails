class Suspension < ActiveRecord::Base

  self.primary_key = :user_id

  validates_presence_of :user

  belongs_to :user

  belongs_to :assignor,
    class_name: :User,
    foreign_key: :assignor_id

end
