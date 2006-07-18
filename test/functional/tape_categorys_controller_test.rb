require File.dirname(__FILE__) + '/../test_helper'
require 'tape_categorys_controller'

# Re-raise errors caught by the controller.
class TapeCategorysController; def rescue_action(e) raise e end; end

class TapeCategorysControllerTest < Test::Unit::TestCase
  def setup
    @controller = TapeCategorysController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
