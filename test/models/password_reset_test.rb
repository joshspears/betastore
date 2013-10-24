require 'test_helper'

class PasswordResetTest < ActiveSupport::TestCase
  test "generates token on create" do
    password_reset = PasswordReset.new
    assert password_reset.save, password_reset.errors.full_messages
  end
end
