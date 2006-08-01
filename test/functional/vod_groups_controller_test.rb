require File.dirname(__FILE__) + '/../test_helper'
require 'vod_groups_controller'

# Re-raise errors caught by the controller.
class VodGroupsController; def rescue_action(e) raise e end; end

class VodGroupsControllerTest < Test::Unit::TestCase
  def setup
    @controller = VodGroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
