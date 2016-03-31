# encoding: utf-8

class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_fill: [166, 236]

  def extension_white_list
    %w(jpg jpeg png)
  end
end