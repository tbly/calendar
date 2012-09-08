class Theater < ActiveRecord::Base
  include VersionedAttributes

  has_many :showtimes

  validates :cs_id,     :presence => true, :numericality => { :only_integer => true }
  validates :name,      :presence => true
  validates :address,   :presence => true
  validates :city,      :presence => true
  validates :state,     :presence => true
  validates :zip,       :presence => true
  validates :phone,     :presence => true
  validates :county,    :presence => true
  validates :ticketing, :inclusion => { :in => [true, false] }

  validates :screens,   :numericality => { :only_integer => true, :allow_nil => true }

  def new_version_id
    DateTime.now.strftime( "%y%m%d" )
  end
end
