class DocumentsController < ApplicationController
  def index
    @documents = Document.order(:path)
  end

  def update
    doc = Document.find(params[:id])
    doc.update!(document_params)
    redirect_back fallback_location: browse_path(document: doc.id)
  end

  def thumbnail
    doc = Document.find(params[:id])
    return head :not_found unless doc.thumbnail?

    send_file doc.thumbnail_path, type: "image/webp", disposition: "inline"
  end

  private

  def document_params
    params.expect(document: [ :tag_list ])
  end
end
