class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def show?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  # private

  # def user_is_owner_or_admin?
  #   booking = Booking.find(record.booking_id)
  #   user == User.find(booking.user_id) || user.admin
  # end
end
