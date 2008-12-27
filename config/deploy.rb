set :application, "merbonrails.kicks-ass.org"
set :user, 'deploy'
set :use_sudo, false
set :scm, :git
set :runner, user
set :repository,  "ssh://deploy@67.207.135.70:30003/var/git/merbonrails.git"
set :deploy_to, "/home/deploy/repos/#{application}"
set :deploy_via, :remote_cache
set :copy_exclude, ['.git', 'Capfile', 'config/deploy.rb']

role :app, application
role :web, application
role :db, application, :primary => true

namespace :deploy do
desc "Symlink database on each release."
task :symlink_database do
run "ln -nfs #{shared_path}/production.db #{release_path}/production.db"
end
desc "Restarting #{application}"
task :restart, :roles => :app, :except => { :no_release => true } do
run "touch #{current_path}/tmp/restart.txt"
end
[:start, :stop].each do |t|
desc "#{t} task is a no-op with passenger"
task t, :roles => :app do ; end
end
end

after 'deploy:update_code', 'deploy:symlink_database'
