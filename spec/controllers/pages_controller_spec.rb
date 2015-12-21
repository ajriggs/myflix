require 'spec_helper'
require 'shoulda-matchers'

describe PagesController do
  it { should use_before_action :require_logout }
end
