set :application, "number_gossip"
set :domain, "numbergossip.com"
set :user, "tankho1"
# TODO Fix this! 
set :repository,  "svn+ssh://doom-toaster.dyndns.org/usr/local/svn/www.tanyakhovanova.com/trunk/number_gossip"

set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy
set :chmod755, "app config db lib public vendor script script/* public/disp*"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
role :db,  domain, :primary => true
