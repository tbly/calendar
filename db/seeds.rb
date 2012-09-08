# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  if User.count == 0 && Role.count == 0
    user = User.new :username => "Admin", :email => "admin@example.org", :password => "password", :password_confirmation => "password"
    user.id = 1
    user.save!

    role1 = Role.new :name => 'Blocked'
    role1.id = 1
    role1.save!

    role2 = Role.new :name => 'Standard'
    role2.id = 2
    role2.save!

    role3 = Role.new :name => 'Trusted'
    role3.id = 3
    role3.save!

    role4 = Role.new :name => 'Moderator'
    role4.id = 4
    role4.save!

    role5 = Role.new :name => 'Administrator'
    role5.id = 5
    role5.save!

    user.role_ids = [2,3,4,5]
    user.save!
  end
end
