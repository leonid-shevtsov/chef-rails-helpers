# Unicorn init.d daemon for a Rails app
#
# Generates a configuration file for unicorn and the daemon control script.
#
# Daemon /etc/init.d/`name`-unicorn can be controlled by root and by the app owner.
#
# Assumes unicorn gem is included in the app.
#
# * name (required) - name of the app
# * app_path - path to the app, default is "/home/`name`/apps/`name`"
# * config_path - where to put the config file, default is "`app_path`/shared"
# * environment - environment to run, default is "production"
# * worker_processes - number of worker processes to run, default is "2"
# * owner and group - owner and group of the app
define :unicorn, {
  :name => nil,
  :app_path => nil,
  :config_path => nil,
  :owner => nil,
  :group => nil,
  :environment => 'production',
  :worker_processes => 2,
  :rvm => false
  } do

  name = params[:name]
  app_path = params[:app_path] || "/home/#{name}/apps/#{name}"
  config_path = params[:config_path] || "#{app_path}/shared"
  the_owner = params[:owner] || name
  the_group = params[:group] || name

  template "#{config_path}/unicorn.rb" do
    owner the_owner
    group the_group
    source 'unicorn.rb.erb'
    variables({
      :app_name => name,
      :app_path => app_path,
      :owner => the_owner,
      :group => the_group,
      :worker_processes => params[:worker_processes]
    })
    cookbook 'rails_helpers'
  end

  template "/etc/init.d/#{name}-unicorn" do
    owner 'root'
    group 'root'
    mode 0755
    source "unicorn.initd.erb"
    variables({
      :app_name => name,
      :app_path => app_path,
      :owner => the_owner,
      :rvm => params[:rvm],
      :environment => params[:environment]
    })
    cookbook 'rails_helpers'
  end

  service "#{name}-unicorn" do
    status_command "/etc/init.d/#{name}-unicorn status"
    supports status: true, restart: true
    action :enable
  end

  # TODO monit (optional)
end