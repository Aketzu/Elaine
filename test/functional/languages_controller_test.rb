require File.dirname(__FILE__) + '/../test_helper'
require 'languages_controller'

# Re-raise errors caught by the controller.
class LanguagesController; def rescue_action(e) raise e end; end

class LanguagesControllerTest < Test::Unit::TestCase
  def setup
    @controller = LanguagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
