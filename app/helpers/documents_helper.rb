module DocumentsHelper
  THUMBNAIL_PLACEHOLDER = {
    "pending"     => "Thumbnail queued…",
    "processing"  => "Generating thumbnail…",
    "error"       => "Thumbnail generation failed",
    "unsupported" => "No preview available for this file type",
    "done"        => "Thumbnail file missing",
  }.freeze

  def thumbnail_placeholder_text(document)
    THUMBNAIL_PLACEHOLDER.fetch(document.thumbnail_status.to_s, document.thumbnail_status.to_s)
  end

  def relative_document_path(document, root = Rails.application.config.dms_root)
    Pathname.new(document.path).relative_path_from(Pathname.new(root.to_s)).to_s
  rescue ArgumentError
    document.path
  end

  def document_folder_tree(documents, root:)
    tree = {}
    documents.each do |doc|
      dir = File.dirname(relative_document_path(doc, root))
      next if dir == "." || dir.start_with?("..")

      cursor = tree
      dir.split(File::SEPARATOR).each do |part|
        cursor[part] ||= {}
        cursor = cursor[part]
      end
    end
    tree
  end
end
