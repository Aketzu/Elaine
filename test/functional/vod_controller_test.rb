require File.dirname(__FILE__) + '/../test_helper'
require 'vod_controller'

# Re-raise errors caught by the controller.
class VodController; def rescue_action(e) raise e end; end

class VodControllerTest < Test::Unit::TestCase
  def setup
    @controller = VodController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
