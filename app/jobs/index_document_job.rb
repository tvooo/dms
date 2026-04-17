class IndexDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    doc = Document.find(document_id)
    Rails.logger.info "IndexDocumentJob: would index ##{doc.id} #{doc.path} (#{doc.mime_type})"
    # TODO: OCR + text extraction + full-text index wiring.
  end
end
