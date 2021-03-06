module ActiveRecordExtension

  extend ActiveSupport::Concern

  def can_destroy?
    self.class.reflect_on_all_associations.all? do |assoc|
      assoc.options[:dependent] != :restrict_with_error ||
      (assoc.macro == :has_one && self.send(assoc.name).nil?) ||
      (assoc.macro == :has_many && self.send(assoc.name).empty?)
    end
  end

end

ActiveRecord::Base.send(:include, ActiveRecordExtension)
