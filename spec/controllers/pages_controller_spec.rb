require 'spec_helper'
require 'shoulda-matchers'

include Testable

describe PagesController do
  it { should use_before_action :require_logout }
end
