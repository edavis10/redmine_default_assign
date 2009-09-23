module DefaultAssign
  module Hooks
    class ExternalSignupsHooks < Redmine::Hook::ViewListener

      def plugin_external_signup_controller_external_signups_create_pre_validate(context={})
        if context[:params] && context[:params][:project] && context[:params][:project][:default_assignee_id].present?
          default_assignee_id = context[:params][:project][:default_assignee_id]
        end

        default_assignee_id ||= Setting.plugin_redmine_external_signup['default_user_assignment']

        if context[:project] && default_assignee_id.present?
          context[:project].default_assignee_id = default_assignee_id
          add_member_if_not_present(context, default_assignee_id)
        end

        true
      end

      private

      def add_member_if_not_present(context, default_assignee_id)
        # Need to make sure the default_assignee is a member also
        unless context[:additional_members].collect(&:user_id).include?(default_assignee_id.to_i)

          roles_setting = Setting.plugin_redmine_external_signup['roles_for_additional_users']
          role_ids = roles_setting.collect(&:to_s) unless roles_setting.blank?

          unless role_ids.blank?
            context[:additional_members] << add_member(:project => context[:project], :role_ids => role_ids, :user_id => default_assignee_id)
          end
        end
      end
      
      # Taken from ExternalSignupsController#add_member
      def add_member(attributes={})
        member = Member.new(:project => attributes[:project],
                            :role_ids => attributes[:role_ids])
        # Redmine groups compatibility
        if defined?(Principal)
          member.principal_id = attributes[:user_id]
        else
          member.user_id = attributes[:user_id]
        end

        member

      end
    end
  end
end
