module MovieParser
  class Image
    def initialize( img )
      @thumb_path  = ASSETS_ROOT_PATH.join( 'thumbs' )
      @img         = img
    end

    def make_thumb
      # Create the thumbnail directory if it does not already exist
      Dir.mkdir( @thumb_path ) unless File.exists?( @thumb_path )

      # Use QuickMagick to create a thumbnail image by resizing the
      # existing file
      i = QuickMagick::Image.read( @img ).first
      i.resize "40x40!"
      i.save @thumb_path.join( File.basename( @img ) ).to_s
    end

    #----------------------------------------------------------------------------
    # Class Methods
    #----------------------------------------------------------------------------
    class << self
      def get_all_images
        Dir.glob( ASSETS_ROOT_PATH.join( 'photos', '*.jpg' ) )
      end
    end
  end
end
