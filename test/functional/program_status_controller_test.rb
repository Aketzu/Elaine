require File.dirname(__FILE__) + '/../test_helper'
require 'program_status_controller'

# Re-raise errors caught by the controller.
class ProgramStatusController; def rescue_action(e) raise e end; end

class ProgramStatusControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProgramStatusController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
