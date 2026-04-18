class Document < ApplicationRecord
  enum :status, { pending: 0, processing: 1, done: 2, error: 3 }, prefix: :index
  enum :thumbnail_status, { pending: 0, processing: 1, done: 2, error: 3, unsupported: 4 }, prefix: true

  validates :path, presence: true, uniqueness: true

  scope :needing_indexing, -> { where(status: [ :pending, :error ]) }

  def filename
    File.basename(path)
  end

  def thumbnail_path
    Rails.root.join("storage/thumbnails/#{content_hash}.webp")
  end

  def thumbnail?
    content_hash.present? && File.exist?(thumbnail_path)
  end
end
