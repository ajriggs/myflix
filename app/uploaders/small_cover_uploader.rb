# encoding: utf-8

class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Override the directory where uploaded files will be stored.
  def store_dir
    "tmp/"
  end

  # Process files as they are uploaded:
  process resize_to_fill: [166, 236]

  def extension_white_list
    %w(jpg jpeg png)
  end
end
