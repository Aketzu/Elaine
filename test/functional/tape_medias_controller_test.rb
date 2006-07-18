require File.dirname(__FILE__) + '/../test_helper'
require 'tape_medias_controller'

# Re-raise errors caught by the controller.
class TapeMediasController; def rescue_action(e) raise e end; end

class TapeMediasControllerTest < Test::Unit::TestCase
  def setup
    @controller = TapeMediasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
