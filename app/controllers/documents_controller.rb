class DocumentsController < ApplicationController
  def index
    @documents = Document.order(:path)
  end

  def thumbnail
    doc = Document.find(params[:id])
    return head :not_found unless doc.thumbnail?

    send_file doc.thumbnail_path, type: "image/webp", disposition: "inline"
  end
end
