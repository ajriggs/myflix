require 'spec_helper'

describe SmallCoverUploader do
  include CarrierWave::Test::Matchers

  before do
    SmallCoverUploader.enable_processing = true
    @small_cover_image = SmallCoverUploader.new
    File.open(File.join(Rails.root, 'public/spec/amadeus_test.jpg')) do |file|
      @small_cover_image.store! file
    end
  end

  after do
    SmallCoverUploader.enable_processing = false
  end

  it 'should scale the image to a default of 166x236' do
    expect(@small_cover_image).to have_dimensions 166, 236
  end
end
