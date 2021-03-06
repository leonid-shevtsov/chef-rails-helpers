# Set up a NGINX site record for a Passenger-based Ruby on Rails site
#
# For this to work, Passenger for nginx must be installed.
#
# Assumes nginx is already installed on the server.
#
# * name (required) - name of the app
# * server_name - domain name for the app's virtual host (default is taken from node['hostnames'][`name`][0])
# * alternate_names - these domain names will 301 redirect to the `server_name`(default is taken from node['hostnames'][`name`][1..-1])
# * port - port to listen on (default is "80")
# * public_path - path to the public directory of the app for asset serving (default is "/home/`name`/apps/`name`/current/public")

define :nginx_site_for_passenger, {
  :name => nil,
  :server_name => nil,
  :altername_names => nil,
  :public_path => nil,
  :port => 80,
  :custom_config => ""
  } do

  app_name = params[:name]
  server_name = params[:server_name] || node['hostnames'][app_name][0]
  alternate_names = Array(params[:alternate_names] || node['hostnames'][app_name][1..-1])
  public_path = params[:public_path] || "/home/#{app_name}/apps/#{app_name}/current/public"
  port = params[:port] || nil
  custom_config = params[:custom_config]

  template "/etc/nginx/sites-available/#{app_name}" do
    source "nginx_site_for_passenger.erb"
    variables :app_name => app_name, :server_name => server_name, :alternate_names => alternate_names, :public_path => public_path, :port => port, :custom_config => custom_config
    cookbook 'rails_helpers'
  end

  execute "ln -s /etc/nginx/sites-available/#{app_name} /etc/nginx/sites-enabled/#{app_name}"  do
    creates "/etc/nginx/sites-enabled/#{app_name}"
    notifies :restart, 'service[nginx]'
  end
end
