module DocumentsHelper
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
