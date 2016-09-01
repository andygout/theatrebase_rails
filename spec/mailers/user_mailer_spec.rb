require 'rails_helper'

describe UserMailer, type: :mailer do
  let(:user) { create :user }
  let(:account_activation_mail) { UserMailer.account_activation(user) }
  let(:password_reset_mail) { UserMailer.password_reset(user) }

  describe 'account activation' do
    it 'renders the headers' do
      expect(account_activation_mail.subject).to eq 'Account activation'
      expect(account_activation_mail.to).to eq [user.email]
      expect(account_activation_mail.from).to eq ['from@example.com']
    end

    it 'renders the body' do
      expect(account_activation_mail.body.encoded).to match user.name
      expect(account_activation_mail.body.encoded).to match user.activation_token
      expect(account_activation_mail.body.encoded).to match CGI::escape(user.email)
    end
  end

  describe 'password reset' do
    it 'renders the headers' do
      user.reset_token = User.new_token
      expect(password_reset_mail.subject).to eq 'Password reset'
      expect(password_reset_mail.to).to eq [user.email]
      expect(password_reset_mail.from).to eq ['from@example.com']
    end

    it 'renders the body' do
      user.reset_token = User.new_token
      expect(password_reset_mail.body.encoded).to match user.name
      expect(password_reset_mail.body.encoded).to match user.reset_token
      expect(password_reset_mail.body.encoded).to match CGI::escape(user.email)
    end
  end
end
