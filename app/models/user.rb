class User < ActiveRecord::Base

  include Validations::User
  include Associations::User

  attr_accessor :remember_token, :activation_token, :reset_token

  before_validation :strip_whitespace, only: :name
  before_save       :downcase_email
  before_create     :create_activation_digest

  scope :non_admin, ->(current_user_id, admin_type) {
    where.not(:id => admin_type.select(:user_id).where.not(user_id: current_user_id).uniq)
  }

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_columns( remember_digest:      User.digest(remember_token),
                    remember_created_at:  Time.zone.now)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def set_log_in_data
    self.log_in_count = 0 if log_in_count == nil
    update_columns( current_log_in_at:  Time.zone.now,
                    last_log_in_at:     current_log_in_at,
                    log_in_count:       log_in_count + 1)
  end

  def forget
    update_columns( remember_digest:      nil,
                    remember_created_at:  nil)
  end

  def activate
    update_columns( activation_digest:  nil,
                    activated_at:       Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns( reset_digest:   User.digest(reset_token),
                    reset_sent_at:  Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    def strip_whitespace
      self.name = self.name.strip
    end

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
