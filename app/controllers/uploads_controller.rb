class UploadsController < ApplicationController
  def create
    current_user.uploads.create(upload_params)

    redirect_to root_path
  end

  private

  def upload_params
    params.require(:upload).permit(:name, :image)
  end
end
