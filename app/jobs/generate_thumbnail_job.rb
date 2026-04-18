require "open3"
require "tmpdir"

class GenerateThumbnailJob < ApplicationJob
  queue_as :default

  THUMBNAIL_SIZE = 512

  def perform(document_id)
    doc  = Document.find(document_id)
    dest = doc.thumbnail_path.to_s

    if File.exist?(dest)
      doc.update!(thumbnail_status: :done) unless doc.thumbnail_status_done?
      return
    end

    doc.update!(thumbnail_status: :processing)
    FileUtils.mkdir_p(File.dirname(dest))

    case
    when doc.mime_type == "application/pdf"
      generate_pdf_thumbnail(doc, dest)
    when doc.mime_type.to_s.start_with?("image/")
      generate_image_thumbnail(doc, dest)
    else
      doc.update!(thumbnail_status: :unsupported)
      Rails.logger.info "GenerateThumbnailJob: skipping ##{doc.id} — unsupported MIME #{doc.mime_type}"
      return
    end

    doc.update!(thumbnail_status: :done)
    Rails.logger.info "GenerateThumbnailJob: wrote #{dest}"
  rescue => e
    doc&.update(thumbnail_status: :error)
    Rails.logger.error "GenerateThumbnailJob: ##{document_id} failed: #{e.class}: #{e.message}"
    raise
  end

  private

  def generate_pdf_thumbnail(doc, dest)
    Dir.mktmpdir do |tmpdir|
      intermediate = File.join(tmpdir, "page")
      run!("pdftoppm", "-singlefile", "-png", "-scale-to", THUMBNAIL_SIZE.to_s, doc.path, intermediate)
      run!("vips", "copy", "#{intermediate}.png", dest)
    end
  end

  def generate_image_thumbnail(doc, dest)
    run!("vipsthumbnail", doc.path, "--size", THUMBNAIL_SIZE.to_s, "-o", dest)
  end

  def run!(*args)
    out, err, status = Open3.capture3(*args)
    raise "#{args.first} failed (#{status.exitstatus}): #{err.presence || out}" unless status.success?
  end
end
