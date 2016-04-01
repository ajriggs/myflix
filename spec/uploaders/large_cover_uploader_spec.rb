require 'spec_helper'

describe LargeCoverUploader do
  include CarrierWave::Test::Matchers

  before do
    LargeCoverUploader.enable_processing = true
    @large_cover_image = LargeCoverUploader.new
    File.open(File.join(Rails.root, 'public/spec/amadeus_test.jpg')) do |file|
      @large_cover_image.store! file
    end
  end

  after do
    LargeCoverUploader.enable_processing = false
  end

  it 'should scale the image to a default of 665x375' do
    expect(@large_cover_image).to have_dimensions 665, 375
  end
end
