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

      Document.find_or_create_by(path: path) do |doc|
        doc.content_hash = Digest::SHA256.file(path).hexdigest
        doc.file_size    = File.size(path)
        doc.mime_type    = Marcel::MimeType.for(Pathname.new(path))
        doc.status       = :pending
      end
    end
  end
end
