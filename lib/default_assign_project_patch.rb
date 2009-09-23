module DefaultAssignProjectPatch
  def self.included(base)
    base.class_eval do
      unloadable

      belongs_to :default_assignee, :class_name => "User"
    end
  end
end
