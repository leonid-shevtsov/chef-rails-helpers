# Logrotate configuration for a a Rails app
#
# Assumes logrotate is already installed on the server
#
# * name (required) - name of the app
# * log_path - path to the logs to be rotated. default is "/home/`name`/apps/`name`/shared/log"
define :rails_log_rotate, {
  :name => nil,
  :log_path => nil,
  } do

  app_name = params[:name]
  log_path = params[:app_path] || "/home/#{app_name}/apps/#{app_name}/shared/log"

  template "/etc/logrotate.d/#{app_name}-app-logs" do
    owner 'root'
    group 'root'
    mode 0600
    source "rails_log_rotate.erb"
    variables :log_path => log_path
    cookbook 'rails_helpers'
  end
end