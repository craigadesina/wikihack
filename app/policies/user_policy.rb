class UserPolicy < ApplicationPolicy
  def index?
    @user.present? and @user.admin?
  end

  def show?
    @user.present? and ((record == @user) or @user.admin?)
  end

  def update?
    show?
  end

  def edit?
    update?
  end

  def destroy?
    unless (record.id == @user.id)
      show?
    else
      false
    end
  end
end