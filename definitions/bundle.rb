# Run bundle install during a Rails deploy
#
# * name (required) - name of the app
# * gemfile_path (required) - path to the Gemfile that has to be installed
# * cache_path (required) - where to install (cache) the gems
define :bundle, :name => nil, :gemfile_path => nil, :cache_path => nil do
  rvm_shell "bundle install" do
    user params[:name]
    cwd params[:gemfile_path]
    code "bundle install --quiet --deployment --without development test --path #{params[:cache_path]}"
  end
end