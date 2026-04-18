class Tag < ApplicationRecord
  belongs_to :parent, class_name: "Tag", optional: true
  has_many :children, class_name: "Tag", foreign_key: :parent_id, dependent: :destroy
  has_many :document_tags, dependent: :destroy
  has_many :documents, through: :document_tags

  validates :name, presence: true, format: { without: %r{/}, message: "cannot contain /" }
  validates :name, uniqueness: { scope: :parent_id, case_sensitive: false }

  scope :roots, -> { where(parent_id: nil) }

  def full_path
    parent ? "#{parent.full_path}/#{name}" : name
  end

  def self.find_or_create_by_path(path)
    path.to_s.split("/").reject(&:blank?).inject(nil) do |parent, segment|
      where(parent: parent).where("LOWER(name) = ?", segment.downcase).first \
        || create!(parent: parent, name: segment)
    end
  end
end
