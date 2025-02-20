class Receipt < ApplicationRecord
  # Relations
  belongs_to :payment
  belongs_to :user
  belongs_to :generated_by, class_name: 'User'

  # Validations
  validates :number, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true

  # Callbacks
  before_validation :generate_number, on: :create

  private

  def generate_number
    date_part = date.strftime('%Y%m%d')
    sequence = Receipt.where('number LIKE ?', "#{date_part}%").count + 1
    self.number = "#{date_part}-#{payment.payment_method.upcase}-#{sequence.to_s.rjust(3, '0')}"
  end
end 