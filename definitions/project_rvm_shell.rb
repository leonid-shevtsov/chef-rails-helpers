# Run a script using the per-project Ruby version with RVM
#
# * name (required) - name of the script
# * cwd (required) - path to the working directory (presumably containing a .ruby-version)
# * code (required) - the code to run
# * user (required) - the user to run the code
define :project_rvm_shell, :name => nil, :cwd => nil, :code => nil, :user => nil do
  the_code = "source /etc/profile.d/rvm.sh; cd '#{params[:cwd]}' && " + params[:code]
  script params[:name] do
    user params[:user]
    cwd params[:cwd]
    code the_code
  end
end