class CollaborationPolicy < ApplicationPolicy

  def create?
    user.admin? || (record.wiki.private? && record.wiki.user_id == user.id)
  end

  def destroy?
    user.admin? || (record.wiki.private? && record.wiki.user_id == user.id)
  end
end