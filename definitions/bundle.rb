# Run bundle install during a Rails deploy
#
# * name (required) - name of the app
# * gemfile_path (required) - path to the Gemfile that has to be installed
# * cache_path (required) - where to install (cache) the gems
define :bundle, :name => nil, :gemfile_path => nil, :cache_path => nil do
  the_user = params[:name]
  the_cwd = params[:gemfile_path]
  the_cache_path = params[:cache_path]
  project_rvm_shell "bundle install" do
    user the_user
    cwd the_cwd
    code "bundle install --quiet --deployment --without development test --path #{the_cache_path}"
  end
end