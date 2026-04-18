require "find"
require "digest"
require "marcel"

class InitialScanJob < ApplicationJob
  queue_as :default

  def perform
    root = Rails.application.config.dms_root
    unless File.directory?(root)
      Rails.logger.warn "InitialScanJob: scan root #{root} does not exist; skipping."
      return
    end

    Rails.logger.info "InitialScanJob: scanning #{root}"

    Find.find(root.to_s) do |path|
      next if File.directory?(path)
      next if File.basename(path).start_with?(".")

      sync_path(path)
    end
  end

  private

  def sync_path(path)
    mtime = File.mtime(path)
    doc   = Document.find_by(path: path)

    if doc.nil?
      create_and_enqueue(path, mtime)
    elsif doc.mtime.to_i != mtime.to_i
      refresh_and_maybe_enqueue(doc, path, mtime)
    end
  end

  def create_and_enqueue(path, mtime)
    doc = Document.create!(
      path: path,
      content_hash: Digest::SHA256.file(path).hexdigest,
      file_size: File.size(path),
      mime_type: Marcel::MimeType.for(Pathname.new(path)),
      mtime: mtime,
      status: :pending,
    )
    enqueue_processing(doc)
  end

  def refresh_and_maybe_enqueue(doc, path, mtime)
    new_hash = Digest::SHA256.file(path).hexdigest

    if new_hash == doc.content_hash
      doc.update!(mtime: mtime)
    else
      doc.update!(
        content_hash: new_hash,
        file_size: File.size(path),
        mime_type: Marcel::MimeType.for(Pathname.new(path)),
        mtime: mtime,
        status: :pending,
      )
      enqueue_processing(doc)
    end
  end

  def enqueue_processing(doc)
    IndexDocumentJob.perform_later(doc.id)
    GenerateThumbnailJob.perform_later(doc.id)
  end
end
