module Associations::User

  extend ActiveSupport::Concern
  include BelongsToCreatorUpdater

  included do
    has_one :admin, dependent: :destroy

    accepts_nested_attributes_for :admin, allow_destroy: true

    has_one :admin_status_assignor, through: :admin, source: :assignor

    has_many :admins, foreign_key: :assignor_id

    has_many :admin_status_assignees, through: :admins, source: :user

    has_one :super_admin, dependent: :destroy

    has_one :suspension, dependent: :destroy

    accepts_nested_attributes_for :suspension, allow_destroy: true

    has_one :suspension_status_assignor, through: :suspension, source: :assignor

    has_many :suspensions, foreign_key: :assignor_id

    has_many :suspension_status_assignees, through: :suspensions, source: :user

    has_many :created_users,
      -> { extending WithUserAssociationExtension },
      class_name: :User,
      foreign_key: :creator_id

    has_many :updated_users, class_name: :User, foreign_key: :updater_id

    has_many :created_productions,
      -> { extending WithUserAssociationExtension },
      class_name: :Production,
      foreign_key: :creator_id

    has_many :updated_productions, class_name: :Production, foreign_key: :updater_id

    has_many :created_theatres,
      -> { extending WithUserAssociationExtension },
      class_name: :Theatre,
      foreign_key: :creator_id

    has_many :updated_theatres, class_name: :Theatre, foreign_key: :updater_id
  end

end
