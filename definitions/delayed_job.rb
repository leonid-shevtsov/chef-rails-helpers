# Name - the name of the app. Must be a valid filename
define :delayed_job, {
  :name => nil,
  :app_path => nil,
  :owner => nil,
  :group => nil,
  :rails_env => 'production',
  :worker_count => 2
  } do

  app_name = params[:name]
  app_owner = params[:owner] || app_name
  app_group = params[:owner] || app_name
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