module VersionedAttributes
  extend ActiveSupport::Concern

  included do
    serialize :attribute_history, Hash
    around_save :save_version
  end

  # TODO: Add some more methods to flesh out functionality, like
  #       pruning old versions, making copies of records with old
  #       version attribute values, etc  --  Sun Aug 19 22:30:30 2012

  def new_version_id
    DateTime.now.to_s
  end

  def versions_after_id( version_id )
    index = self.version_ids.index( version_id )
    return nil if index.nil?

    range = (index + 1)..(self.version_ids.count-1)
    self.version_ids[range]
  end

  def version_ids
    self.attribute_history.keys.sort
  end

  def attributes_version_at( version_id )
    self.attribute_history[version_id]
  end

  def reset_to_version_at!( version_id )
    attributes = self.attributes_version_at( version_id )
    raise ActiveRecord::UnknownAttributeError, "#{self.class} has no previous version with id #{version_id}" if attributes.blank?

    self.assign_attributes( attributes ) if attributes_changed?( attributes )
  end

  def reset_to_version_at( version_id )
    status = false

    begin
      self.reset_to_version_at!( version_id )
      status = true
    rescue ActiveRecord::UnknownAttributeError
      status = false
    end

    status
  end

  private

  def attributes_changed?( attributes )
    attributes != attributes_version_hash
  end

  def save_version
    # Calculate and store a hash of the attributes keyed by the
    # version id
    version_id = self.new_version_id
    self.attribute_history[version_id] = attributes_version_hash

    yield

    # If this is on creation, the record id will be nil, in which case
    # perform a raw update to the attribute version history to store
    # the id after record creation
    attributes = self.attribute_history[version_id]
    if attributes['id'] == nil
      attributes['id'] = self.id
      self.update_column( 'attribute_history', self.attribute_history.to_yaml )
    end
  end

  def attributes_version_hash
    serialized_attributes = self.serializable_hash

    [ 'updated_at', 'created_at', 'attribute_history' ].each do |field|
      serialized_attributes.delete( field )
    end

    serialized_attributes
  end
end
