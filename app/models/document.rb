class Document < ApplicationRecord
  enum :status, { pending: 0, processing: 1, done: 2, error: 3 }

  validates :path, presence: true, uniqueness: true

  scope :needing_indexing, -> { where(status: [ :pending, :error ]) }

  def filename
    File.basename(path)
  end
end
