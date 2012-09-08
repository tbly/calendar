require 'net/ftp'
require 'fileutils'

include FileUtils

# This class handles the connection between the production
# server and the cinema FTP server.
module MovieParser
  class FileUtilityError < StandardError
  end

  class FileUtility
    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------
    attr_accessor :movie_file, :showtimes_file, :theaters_file

    #----------------------------------------------------------------------------
    # Public Instance Methods
    #----------------------------------------------------------------------------
    def initialize( version = MovieParser.today )
      @temp_dir = MovieParser::ASSETS_TEMP_PATH
      @root_dir = MovieParser::ASSETS_ROOT_PATH

      @version = version
    end

    def download_raw_data
      # Initialize the temp directory if it's not found
      mkdir @temp_dir unless File.exist?( @temp_dir )

      # Download all pertinent files based on the version member value
      files = [ @version + ".zip" , "photos.tar"]

      ftp = Net::FTP.new('ftp.cinema-source.com')
      ftp.passive = true

      ftp.login('iaicn', '1waCNw')

      files.each do |file|
        print "Getting file #{file}..."
        ftp.getbinaryfile( file , @temp_dir.join( "#{file}" ) )
        puts ' done!'
      end
    end

    def unpack_photos
      photos_dir = @root_dir.join( 'photos' )
      backup_dir = @root_dir.join( 'photos.bkp' )

      photos_archive_file = @temp_dir.join( 'photos.tar' )

     # Raise error unless photos archive file exists
      unless File.exist?( photos_archive_file )
        raise FileUtilityError.new('photos.tar was not downloaded')
      end

      # Initialize the photos directory if it's not found
      mkdir_p photos_dir unless File.exist?( photos_dir )

      print 'Moving existing photos to backup dir... '
      rm_rf backup_dir
      mv photos_dir, backup_dir
      puts ' done!'

      print "Unpacking photos.tar into #{photos_dir}..."
      mkdir_p photos_dir
      success = system( "/bin/tar -xf #{photos_archive_file} -C #{photos_dir}" )
      puts ' done!'

      # Unless unpacking completed successfully, roll back changes and
      # raise an error
      unless ((success && $?.exitstatus == 0) &&
                        Dir[@root_dir.join( 'photos', '**', '*')].length > 2)
        roll_back
        raise FileUtilityError.new('An error occured, replacing with backups')
      end
    end

    def unpack_xml
      # Create backups of existing XML files
      print "Creating #{@temp_dir}/*.xml.bkp files..."
      Dir[@temp_dir.join( '*.xml' )].each { |f| mv f, f + ".bkp" }
      puts ' done!'

      # Unpack current version of XML files, rolling back unless
      # unpacking succeeds
      xmlfile = @temp_dir.join( @version + '.zip' )
      catch_exception if xmlfile.blank?

      puts "Unpacking and creating #{xmlfile} file"
      success = system("unzip #{xmlfile} -d #{@temp_dir}/")

      system("mv #{@temp_dir}/*I.XML #{@temp_dir.join('movies.xml')}")
      system("mv #{@temp_dir}/*S.XML #{@temp_dir.join('showtimes.xml')}")
      system("mv #{@temp_dir}/*T.XML #{@temp_dir.join('theaters.xml')}")

      # Unless unpacking completed successfully, roll back changes and
      # raise an error
      unless ((success && $?.exitstatus == 0)   ||
                              (File.size?(@temp_dir.join('movies.xml')) == nil) ||
                              (File.size?(@temp_dir.join('showtimes.xml')) == nil) ||
                              (File.size?(@temp_dir.join('theaters.xml')) == nil))
        roll_back
        raise FileUtilityError.new('An error occured, replacing with backups')
      end
    end

    def roll_back
      # Restore the previous .xml files
      Dir[@temp_dir.join( '*.xml.bkp' )].each { |f| mv f, f.chomp('.bkp') }

      #restore the previous photos dir
      rm_rf @root_dir.join( 'photos' )
      mv @root_dir.join( 'photos.bkp' ), @root_dir.join( 'photos' )
    end
  end
end
