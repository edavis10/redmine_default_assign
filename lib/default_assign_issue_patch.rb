# Patches Redmine's Issues dynamically.  Adds a default assignee per
# project.
#
# Based heavily on edavis10's stuff-to-do plugin
#
module DefaultAssignIssuePatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      before_save :assign_default_assignee

    end
  end

  module InstanceMethods
    # If the issue isn't assigned to someone and a default assignee
    # is set, set it.
    def assign_default_assignee
        self.assigned_to_id ||= @project.default_assignee_id
    end
  end
end
