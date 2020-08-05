class Discount < ApplicationRecord
  validates_presence_of :percentage, :number_needed
  validates_inclusion_of :percentage, in: 1..100
  validates :number_needed, numericality: {greater_than: 0}
  belongs_to :item
  belongs_to :merchant
end
