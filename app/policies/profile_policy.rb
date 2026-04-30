class ProfilePolicy < ApplicationPolicy
  def show?
    user.present?
  end
end
