class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.published? || record.author_id == user&.id || user&.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.published
    end
  end
end
