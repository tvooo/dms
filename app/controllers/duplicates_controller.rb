class DuplicatesController < ApplicationController
  def index
    @documents = Document.duplicates.order(:path)
  end
end
