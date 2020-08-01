class Discount < ApplicationRecord
  validates_presence_of :percentage, :number_needed
  belongs_to :item
  belongs_to :merchant
end
