class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :child
  belongs_to :category
  monetize :amount_cents
  mount_uploader :receipt, PhotoUploader

  attr_writer :current_step

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[children date]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

end
