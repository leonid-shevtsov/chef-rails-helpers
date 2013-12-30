# Name - the name of the app. Must be a valid filename
define :thinking_sphinx, {
  :name => nil,
  :app_path => nil,
  :port => nil,
  :owner => nil,
  :group => nil,
  :rails_env => 'production'
  } do

  app_name = params[:name]
  app_owner = params[:owner] || app_name
  app_group = params[:owner] || app_name
  app_path = params[:app_path] || "/home/#{app_owner}/apps/#{app_name}"
  port = params[:port]
  rails_env = params[:rails_env]
  if port.nil?
    port = $thinking_sphinx_port ||= 9312
    $thinking_sphinx_port += 1
  end

  file "#{app_path}/shared/sphinx.yml" do
    action :delete
  end

  template "#{app_path}/shared/thinking_sphinx.yml" do
    owner app_owner
    group app_group
    source "thinking_sphinx.yml.erb"
    variables :app_name => app_name, :app_path => app_path, :port => port, :rails_env => rails_env
    cookbook 'rails_helpers'
  end

  directory "#{app_path}/shared/db" do
    owner app_owner
    group app_group
    mode 0700
  end

  directory "#{app_path}/shared/db/sphinx" do
    owner app_owner
    group app_group
    mode 0700
  end

  template "/etc/init.d/#{app_name}-sphinx" do
    owner 'root'
    group 'root'
    mode 0755
    source "sphinx.initd.erb"
    variables :app_name => app_name, :app_path => app_path, :owner => app_owner, :rails_env => rails_env
    cookbook 'rails_helpers'
  end

  service "#{app_name}-sphinx" do
    status_command "/etc/init.d/#{app_name}-sphinx status"
    supports status: true, restart: true
    action [:enable, :start]
  end

  # template "/etc/monit/conf.d/#{app_name}-sphinx.conf" do
  #   owner 'root'
  #   group 'root'
  #   mode 0700
  #   source "sphinx.monit.erb"
  #   variables :app_name => app_name
  #   cookbook 'leonid_shevtsov'
  #   notifies :restart, 'service[monit]'
  #   notifies :run, "execute[enable-monit-#{app_name}-sphinx]"
  # end

  # execute "enable-monit-#{app_name}-sphinx" do
  #   command "monit monitor #{app_name}-sphinx"
  #   action :nothing
  # end
end