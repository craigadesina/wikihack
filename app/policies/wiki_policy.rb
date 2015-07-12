class WikiPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    index?
  end

  def create?
    @user.present?#and record.user_id == @user.id
  end

  def new?
    create?
  end

  def update?
    @user.present?
  end

  def edit?
    update?
  end

  def destroy?
    @user.present? and (record.user_id == @user.id || @user.admin?)
  end

  def hidable?
    if @user.present?
      record.user_id == @user.id and (@user.admin? or @user.premium?)
    else
      false
    end
  #need to finish this off
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

 
  class Scope
    attr_reader :user, :scope
 
    def initialize(user, scope)
      @user = user
      @scope = scope
    end
 
    def resolve

      unless user.nil?
        wikis = []
        if user.role == 'admin'
          wikis = scope.all # if the user is an admin, show them all the wikis
        elsif user.role == 'premium'
          all_wikis = scope.all
          all_wikis.each do |wiki|
            if wiki.public? || wiki.owner == user || wiki.users.include?(user)
              wikis << wiki # if the user is premium, only show them public wikis, or that private wikis they created, or private wikis they are a collaborator on
            end
          end
        else # this is the lowly standard user
          all_wikis = scope.all
          wikis = []
          all_wikis.each do |wiki|
            if wiki.public? || wiki.users.include?(user)
              wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
            end
          end
        end
        wikis # return the wikis array we've built up
      else
        scope.public_viewable
      end
    end
  end
end
  
#code below is irrelevant now
  #class Scope
   # attr_reader :user, :scope

    #def initialize(user, scope)
     # @user = user
      #@scope = scope
    #end

    #def resolve
     # if user.present? and (@user.admin? or @user.premium?)
        #scope.all
      #else
       # scope.public_viewable
      #end
    #end
  #end
#end