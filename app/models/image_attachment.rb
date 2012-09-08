# t.string      :content_file_name
# t.string      :content_content_type
# t.string      :content_file_size
# t.integer     :content_updated_at   
# t.integer     :attachable_id
# t.string      :attachable_type 
# t.timestamps
      
class ImageAttachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  has_attached_file :content, :styles => { :large => "600x600>", :medium => "300x300>", :thumb => "100x100>" } # , :storage => :s3

  def url(*args)
    content.url(*args)
  end

  def name
    content_file_name
  end

  def content_type
    content_content_type
  end

  def file_size
    content_file_size
  end

end