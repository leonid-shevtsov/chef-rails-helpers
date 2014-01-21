define :airbrake_deploy_notification, {
  :name => nil,
  :path => nil,
  :environment => nil,
  :key => nil,
  :host => nil,
  } do

    name = params[:name]
    path = params[:path] || "/home/#{name}/apps/#{name}/current"
    environment = params[:environment] || 'production'
    key = params[:key] || node[:airbrake][name][:key]
    host = params[:host] || node[:airbrake][name][:host] || 'airbrake.io'

    bash "airbrake deploy notification for #{name}" do
      code %Q{cd #{path} && curl -d "api_key=#{key}&deploy[local_username]=chef&deploy[rails_env]=#{environment}&deploy[scm_revision]=`git rev-parse HEAD`&deploy[scm_repository]=`git config --get remote.origin.url`" http://#{host}/deploys.txt}
    end
end