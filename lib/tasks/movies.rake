namespace :movies do
  desc "parses the movie listing data and imports it into our database"
  task :import_data => :environment do
    # TODO: Determine if there are any additional steps to this process  --  Sun Jul 22 11:40:48 2012
    MovieParser::Parser.import_movies
  end

  desc "rolls movie data in database back to previous version"
  task :rollback => :environment do
    record_types = [Movie, Theater, Showtime]

    ActiveRecord::Base.transaction do
      record_types.each do |type|
        type.all.each do |record|
          previous_version_id = record.version_ids[-2]
          newer_versions = record.versions_after_id( previous_version_id )

          if newer_versions
            if record.reset_to_version_at( previous_version_id )
              puts "Rolling back #{type.to_s} id #{record.id} to version #{previous_version_id}"
              record.save!

              # TODO: Decide if versions past the rollback version
              # should be discarded  --  Sun Sep  2 11:15:39 2012
            end
          else
            # TODO: Handle case where this is most recent version,
            #       i.e. record was added in last import... Discard
            #       it? Keep it?  --  Sun Sep  2 11:14:02 2012
          end
        end
      end
    end
  end
end
