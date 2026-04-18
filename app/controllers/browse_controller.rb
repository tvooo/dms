class BrowseController < ApplicationController
  def index
    @root            = Rails.application.config.dms_root
    @documents       = Document.order(:path)
    @tree            = helpers.document_folder_tree(@documents, root: @root)
    @current_folder  = params[:folder].to_s

    @folder_documents = @documents.select do |doc|
      dir = File.dirname(helpers.relative_document_path(doc, @root))
      @current_folder.present? ? dir == @current_folder : dir == "."
    end

    @selected_document = Document.find_by(id: params[:document])
  end
end
