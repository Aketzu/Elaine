require File.dirname(__FILE__) + '/../test_helper'
require 'vods_controller'

# Re-raise errors caught by the controller.
class VodsController; def rescue_action(e) raise e end; end

class VodsControllerTest < Test::Unit::TestCase
  def setup
    @controller = VodsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
