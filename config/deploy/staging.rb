set :branch, 'master'

#server 'ec2-184-169-145-220.us-west-1.compute.amazonaws.com', :app, :web, :db, :primary => true
server 'staging.icnow.net', :app, :web, :db, :primary => true
