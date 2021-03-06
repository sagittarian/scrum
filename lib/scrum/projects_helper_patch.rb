require_dependency "projects_helper"

module Scrum
  module ProjectsHelperPatch
    def self.included(base)
      base.class_eval do

        def project_settings_tabs_with_scrum
          tabs = project_settings_tabs_without_scrum
          if User.current.allowed_to?(:manage_sprints, @project)
            index = tabs.index({:name => "versions", :action => :manage_versions,
                                :partial => "projects/settings/versions",
                                :label => :label_version_plural})
            if index
              tabs.insert(index,
                          {:name => "sprints", :action => :edit_sprints,
                           :partial => "projects/settings/sprints",
                           :label => :label_sprint_plural})
              tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
            end
          end
          return(tabs)
        end
        alias_method_chain :project_settings_tabs, :scrum

      end
    end
  end
end
