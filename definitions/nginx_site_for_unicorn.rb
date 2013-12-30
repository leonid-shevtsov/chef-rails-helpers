# Name - the name of the app. Must be a valid filename
define :nginx_site_for_unicorn, {
  :name => nil,
  :server_name => nil,
  :altername_names => nil,
  :public_path => nil,
  :port => 80
  } do

  app_name = params[:name]
  server_name = params[:server_name] || node['hostnames'][app_name][0]
  alternate_names = Array(params[:alternate_names] || node['hostnames'][app_name][1..-1])
  public_path = params[:public_path] || "/home/#{app_name}/apps/#{app_name}/current/public"
  port = params[:port] || nil

  template "/etc/nginx/sites-available/#{app_name}" do
    source "nginx_site_for_unicorn.erb"
    variables :app_name => app_name, :server_name => server_name, :alternate_names => alternate_names, :public_path => public_path, :port => port
    cookbook 'rails_helpers'
  end

  execute "ln -s /etc/nginx/sites-available/#{app_name} /etc/nginx/sites-enabled/#{app_name}"  do
    creates "/etc/nginx/sites-enabled/#{app_name}"
    notifies :restart, 'service[nginx]'
  end
end