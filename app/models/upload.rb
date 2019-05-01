class Upload < ApplicationRecord
  has_one_attached :image

  before_save do
    self.name = image.filename.base if name.blank?
  end
end
