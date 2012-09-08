class Arrest < ActiveRecord::Base
  validates :address,  :presence => true
  validates :date,     :presence => true
  validates :incident, :presence => true, :uniqueness => true
  validates :name,     :presence => true
  validates :dob,      :presence => true
  validates :age,      :presence => true
  validates :location, :presence => true
  validates :cited,    :inclusion => { :in => [true, false] }
  validates :arrested, :inclusion => { :in => [true, false] }
  validates :charges,  :presence => true
end
