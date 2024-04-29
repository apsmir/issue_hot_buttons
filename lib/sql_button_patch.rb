class SqlButtonPatch < Redmine::Hook::Listener
  def controller_issues_edit_after_save(context = { })
    execute_sql(context)
  end

  def controller_issues_new_after_save(context = { })
    execute_sql(context)
  end

  def controller_issues_bulk_edit_before_save(context = { })
    execute_sql(context)
  end

  def execute_sql(context)
    hot_button_sql_file = context[:params][:hot_button_sql_file]
    return if hot_button_sql_file.blank?
    file = __FILE__.gsub('lib/sql_button_patch.rb','sql/'+hot_button_sql_file)
    if !File.exist?(file)
      Rails.logger.error('HotButton: sql file not found '+file)
      return;
    end
    id = context[:issue].id.to_s
    sql = File.read(file)
    sql = sql.gsub('%id%', id)
    begin
      ActiveRecord::Base.connection.execute(sql)
      Rails.logger.info('HotButton successfully executed sql '+sql)
    rescue Exception => e
      Rails.logger.error('HotButton execute sql error:  '+ e.message)
    end
  end
end
