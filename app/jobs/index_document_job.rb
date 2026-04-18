class IndexDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    doc = Document.find(document_id)
    doc.update!(status: :processing)
    Rails.logger.info "IndexDocumentJob: indexing ##{doc.id} #{doc.path} (#{doc.mime_type})"

    # TODO: real OCR + text extraction + full-text indexing. Sleep for now so
    # status transitions are observable in the UI.
    sleep 1

    doc.update!(status: :done, indexed_at: Time.current)
  rescue => e
    doc&.update(status: :error)
    Rails.logger.error "IndexDocumentJob: ##{document_id} failed: #{e.class}: #{e.message}"
    raise
  end
end
