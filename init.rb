Redmine::Plugin.register :issue_hot_buttons do
  Rails.logger.info 'Plugin issue_hot_buttons register'
  name 'Issue Hot Buttons'
  author 'Alexey Smirnov'
  description 'Plugin for Redmine that add buttons for often used actions to issue page'
  version '5.0'
  settings :partial => 'hot_buttons/settings'
  url 'https://github.com/apsmir/issue_hot_buttons'
end

require_dependency File.dirname(__FILE__) + '/lib/sql_button_patch'

Rails.application.config.after_initialize do
  IssuesController.send(:prepend, IssueHotButtons::IssuesControllerPatch)
end

class Hooks < Redmine::Hook::ViewListener
  render_on :view_issues_show_details_bottom,
    :partial => 'hot_buttons/assets',
    :layout => false
end
