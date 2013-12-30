define :database_yml, {
  :name => nil,
  :path => nil,
  :environments => nil,
  :adapter => 'mysql2',
  :encoding => 'utf8',
  :database => nil,
  :username => nil,
  :password => nil,
  :owner => nil,
  :group => nil
  } do

  environments = params[:environments] || {
    'production' => {
      'adapter' => params[:adapter],
      'encoding' => params[:encoding],
      'database' => params[:database] || params[:name],
      'username' => params[:username] || params[:database] || params[:name],
      'password' => params[:password] || ''
    }
  }

  environments.each do |name, environment|
    environment['encoding'] ||= 'utf8'
  end

  the_owner = params[:owner] || params[:name]
  the_group = params[:owner] || params[:name]

  file "#{params[:path]}/database.yml" do
    content YAML.dump(environments)
    owner the_owner
    group the_group
  end
end