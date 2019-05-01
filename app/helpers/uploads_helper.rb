module UploadsHelper
  def upload_original_name(upload)
    original_name = upload.image.filename.base
    "Originally - \'#{original_name}\'" unless upload.name == original_name
  end
end
