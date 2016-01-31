module WithUserAssociationExtension

  def build_with_user(attributes = {}, user)
    @password = SecureRandom.urlsafe_base64
    attributes[:password] = @password
    attributes[:password_confirmation] = @password

    attributes[:creator] ||= user
    attributes[:updater] ||= user

    build(attributes)
  end

end
