class Document < ApplicationRecord
  enum :status, { pending: 0, processing: 1, done: 2, error: 3 }, prefix: :index
  enum :thumbnail_status, { pending: 0, processing: 1, done: 2, error: 3, unsupported: 4 }, prefix: true

  has_many :document_tags, dependent: :destroy
  has_many :tags, through: :document_tags

  validates :path, presence: true, uniqueness: true

  scope :needing_indexing, -> { where(status: [ :pending, :error ]) }
  scope :duplicates, -> {
    select("DISTINCT ON (content_hash) *")
      .where.not(content_hash: nil)
    #   .where("id IN (SELECT id FROM documents WHERE content_hash = documents.content_hash ORDER BY created_at DESC OFFSET 1)")
      .order(:content_hash, created_at: :desc)
  }

  def filename
    File.basename(path)
  end

  def thumbnail_path
    Rails.root.join("storage/thumbnails/#{content_hash}.webp")
  end

  def thumbnail?
    content_hash.present? && File.exist?(thumbnail_path)
  end

  def tag_list
    tags.map(&:full_path).sort.join(" ")
  end

  def tag_list=(str)
    paths = str.to_s.split(/\s+/).reject(&:blank?)
    self.tags = paths.map { |p| Tag.find_or_create_by_path(p) }
  end
end
