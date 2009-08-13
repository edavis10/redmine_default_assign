module DefaultAssignProjectPatch
  def self.included(base)
    base.class_eval do
      unloadable

      has_one :default_assignee, :through => :members, :source => :user
    end
  end
end
