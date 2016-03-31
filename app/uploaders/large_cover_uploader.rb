# encoding: utf-8

class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_fill: [665, 375]

  def extension_white_list
    %w(jpg jpeg png)
  end
end
