namespace :local_news do
  desc "Updates local news data from configured news feeds"
  task :update_data => :environment do
    LocalNewsSource.parse_all_feeds
  end
end
