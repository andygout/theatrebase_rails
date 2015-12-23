module WithUserAssociationExtension
  def build_with_user(attributes = {}, user)
    attributes[:creator] ||= user
    build(attributes)
  end
end
