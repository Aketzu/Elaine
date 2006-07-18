require File.dirname(__FILE__) + '/../test_helper'
require 'programdescriptions_controller'

# Re-raise errors caught by the controller.
class ProgramdescriptionsController; def rescue_action(e) raise e end; end

class ProgramdescriptionsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProgramdescriptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
