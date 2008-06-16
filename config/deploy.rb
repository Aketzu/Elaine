set :application, "Elaine3"
set :repository,  "https://svn.nodeta.fi/elaine2006/trunk"


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "elaine.aketzu.net"
role :web, "elaine.aketzu.net"
role :db,  "elaine.aketzu.net", :primary => true
