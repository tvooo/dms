class TagsController < ApplicationController
  def index
    @roots  = Tag.roots.includes(:children).order(:name)
    @counts = Document.joins(:tags).group("tags.id").count
  end

  def show
    @tag               = Tag.find(params[:id])
    @documents         = @tag.documents.order(:path)
    @children          = @tag.children.order(:name)
    @roots             = Tag.roots.includes(:children).order(:name)
    @selected_document = Document.find_by(id: params[:document])
  end
end
