require File.dirname(__FILE__) + '/../test_helper'
require 'broadcast_logs_controller'

# Re-raise errors caught by the controller.
class BroadcastLogsController; def rescue_action(e) raise e end; end

class BroadcastLogsControllerTest < Test::Unit::TestCase
  def setup
    @controller = BroadcastLogsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
