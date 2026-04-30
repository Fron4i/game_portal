class CommentPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    return false if user.blank?

    user.admin? || record.user_id == user.id
  end
end
