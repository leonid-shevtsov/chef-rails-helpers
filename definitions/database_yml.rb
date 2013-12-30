# Sets up a database.yml file for Ruby on Rails, given the usual set of options
# * name (required) - name of the app
# * path (required) - path to the containing directory for the database.yml file
# * owner - owner of the file (default same as `name')
# * owner - owner group of the file (default same as `name')
# * environments - contents of the database.yml file
# * if there's only one `production` environment, define these options on the top level and don't define the `environments` hash:
# * * adapter (default is "mysql2")
# * * encoding (default is "utf8")
# * * database (default same as `name`)
# * * username (default same as `database`)
# * * password (default is blank)
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