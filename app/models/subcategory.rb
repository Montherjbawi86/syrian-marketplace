class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :listings, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :category_id }
  validates :name_ar, presence: true

  scope :active, -> { where(active: true) }

  def to_s
    name_ar
  end
end
