class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    user.roles.map{|r| r.name.downcase.to_sym}.each do |role|
      case role
      when :blocked
        # TODO: Implement auth for blocked role  --  Mon Oct 31 15:12:49 2011
      when :standard
        # TODO: Implement auth for standard role  --  Mon Oct 31 15:13:15 2011
      when :trusted
        # TODO: Implement auth for trusted role  --  Mon Oct 31 15:13:59 2011
      when :moderator
        # TODO: Implement auth for moderator role  --  Mon Oct 31 15:14:09 2011
      when :administrator
        # TODO: Implement auth for administrator role  --  Mon Oct 31 15:14:20 2011
      else
        # Shouldn't ever hit this block, but it's defined in case some
        # special error case needs to be handled
      end
    end

    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

  end
end
