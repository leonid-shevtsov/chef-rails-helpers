# Thinking Sphinx for a Rails app
#
# Provides configuration files and directories. Creates an init.d daemon for searchd, that starts on system reboot.
#
# Daemon `name`-sphinx can be controlled by root and by the app owner.
#
# Assumes that Sphinx is already installed on the server, and thinking_sphinx v3 is installed in the app.
#
# * name (required) - name of the app
# * app_path - path to the app (default is "/home/`owner`/apps/`name`")
# * rails_env - environment of the app (default is "production")
# * port - port for the searchd daemon; default is to start from 9312 and increment by 1 for each new searchd instance (so multiple instances on one server are supported)
# * owner and group - owner and group of the app
# * monit - set to false to not generate Monit configuration. Default is true
define :thinking_sphinx, {
  :name => nil,
  :app_path => nil,
  :port => nil,
  :owner => nil,
  :group => nil,
  :rails_env => 'production',
  :monit => true
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

  if params[:monit]
    template "/etc/monit/conf.d/#{app_name}-sphinx.conf" do
      owner 'root'
      group 'root'
      mode 0700
      source "sphinx.monit.erb"
      variables :app_name => app_name
      cookbook 'rails_helpers'
      notifies :run, "execute[enable-monit-#{app_name}-sphinx]", :immediately
    end

    execute "enable-monit-#{app_name}-sphinx" do
      command "monit monitor #{app_name}-sphinx"
      action :nothing
    end
  end
end