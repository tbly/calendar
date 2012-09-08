desc "parses the police blotter and imports it into our database"
task :police_blotter, [:include_pre_days] => :environment do |t, args|
  args.with_defaults(:include_pre_days => 0)
  previous_days = args.include_pre_days.to_i

  Blotter::ArrestScraper.import_arrest_data( previous_days )
end
