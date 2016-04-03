class Admin < ActiveRecord::Base

  self.primary_key = :user_id

  validates :user,
    presence: true

  validates :assignor,
    presence: true

  belongs_to :user

  belongs_to :assignor,
    class_name: :User,
    foreign_key: :assignor_id

end
