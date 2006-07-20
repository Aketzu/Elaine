require File.dirname(__FILE__) + '/../test_helper'
require 'tape_program_links_controller'

# Re-raise errors caught by the controller.
class TapeProgramLinksController; def rescue_action(e) raise e end; end

class TapeProgramLinksControllerTest < Test::Unit::TestCase
  def setup
    @controller = TapeProgramLinksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
