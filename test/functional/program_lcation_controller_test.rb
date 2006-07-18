require File.dirname(__FILE__) + '/../test_helper'
require 'program_lcation_controller'

# Re-raise errors caught by the controller.
class ProgramLcationController; def rescue_action(e) raise e end; end

class ProgramLcationControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProgramLcationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
