require File.dirname(__FILE__) + '/../test_helper'
require 'sidebars_controller'

# Re-raise errors caught by the controller.
class SidebarsController; def rescue_action(e) raise e end; end

class SidebarsControllerTest < Test::Unit::TestCase
  def setup
    @controller = SidebarsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
