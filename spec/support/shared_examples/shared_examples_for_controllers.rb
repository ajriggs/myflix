require 'spec_helper'

shared_examples 'user can only access if logged in' do
  it 'receives the #require_login method from ApplicationController' do
    test_login
    expect(controller).to receive :require_login
    action
  end
end

shared_examples 'user can only access if logged out' do
  it 'receives the #require_logout method from ApplicationController' do
    test_logout
    expect(controller).to receive :require_logout
    action
  end
end
