class DocumentsController < ApplicationController
  def index
    @documents = Document.order(:path)
  end
end
