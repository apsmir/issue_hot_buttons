require 'redmine'
require_dependency File.dirname(__FILE__) + '/lib/sql_button_patch'
#require_dependency 'sql_button_patch'

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  object_to_prepare = Dispatcher
else
  object_to_prepare = Rails.configuration
end

object_to_prepare.to_prepare do
  require File.dirname(__FILE__) + '/lib/issues_controller_patch.rb'
  IssuesController.send(:include, IssueHotButtons::IssuesControllerPatch)
end

class Hooks < Redmine::Hook::ViewListener
  render_on :view_issues_show_details_bottom,
    :partial => 'hot_buttons/assets',
    :layout => false
end

Redmine::Plugin.register :issue_hot_buttons do
  name 'Issue Hot Buttons'
  author 'Alexey Smirnov'
  description 'Plugin for Redmine that add buttons for often used actions to issue page'
  version '5.0'
  settings :partial => 'hot_buttons/settings'
  url 'https://github.com/apsmir/issue_hot_buttons'
end
