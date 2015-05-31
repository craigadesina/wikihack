class WikiPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    index?
  end

  def create?
    @user.present? and record.user == @user
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
    @user.present? and (record.user == @user || @user.admin?)
  end
end