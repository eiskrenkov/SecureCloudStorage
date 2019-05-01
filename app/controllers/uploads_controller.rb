class UploadsController < ApplicationController
  before_action :set_upload

  def create
    current_user.uploads.create(upload_params)

    redirect_to root_path
  end

  def destroy
    @upload.destroy

    redirect_to root_path
  end

  def show
  end

  def show_image
    image = @upload.image
    send_data image.download.string.force_encoding(Encoding::BINARY), filename: image.filename.base,
                                                                      content_type: image.content_type
  end

  private

  def set_upload
    @upload = Upload.find(params[:id])
  end

  def upload_params
    params.require(:upload).permit(:name, :image)
  end
end
