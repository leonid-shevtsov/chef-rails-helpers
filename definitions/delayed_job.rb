# Sets up a delayed job init.d daemon for a Rails app
#
# The daemon will start on system reboot.
#
# Daemon /etc/init.d/`name`-delayed_job can be controlled by root and by the app owner.
#
# Assumed that delayed_job is installed in the app and a `script/delayed_job` is present
#
# * name (required) - the name of the app
# * app_path - path to the app's root (without /current) - default is "/home/`name`/apps/`name`"
# * rails_env - environment to run (default is "production")
# * worker_count - count of delayed job workers to start, default is "2"
# * owner - user that will run the daemon, default same as `name`
define :delayed_job, {
  :name => nil,
  :app_path => nil,
  :owner => nil,
  :rails_env => 'production',
  :worker_count => 2
  } do

  app_name = params[:name]
  app_owner = params[:owner] || app_name
  app_path = params[:app_path] || "/home/#{app_owner}/apps/#{app_name}"
  rails_env = params[:rails_env]
  worker_count = params[:worker_count]

  template "/etc/init.d/#{app_name}-delayed_job" do
    owner 'root'
    group 'root'
    mode 0755
    source "delayed_job.initd.erb"
    variables :app_name => app_name, :app_path => app_path, :owner => app_owner, :rails_env => rails_env, :worker_count => worker_count
    cookbook 'rails_helpers'
  end

  service "#{app_name}-delayed_job" do
    status_command "/etc/init.d/#{app_name}-delayed_job status"
    supports status: true, restart: true
    action [:enable, :start]
  end
end