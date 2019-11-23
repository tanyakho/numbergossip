# -*- mode:ruby -*-

load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

# ========================
#     For Passenger Apps
# ========================

namespace :deploy do

  task :start, :roles => :app do
    run "rm -rf /home/#{user}/numbergossip.com;ln -s #{current_path}/public /home/#{user}/numbergossip.com"
  end

  task :restart, :roles => :app do
    run "cd #{current_path} && chmod 755 #{chmod755}"
    run "cd #{current_path} && touch tmp/restart.txt"
  end

end

"Symlink the app's database.yml to the one in shared/config"
task "symlink_database_yml" do
  run "ln -nsf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

after "deploy:update_code", "symlink_database_yml"
