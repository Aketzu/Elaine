require File.dirname(__FILE__) + '/../test_helper'
require 'file_locations_controller'

# Re-raise errors caught by the controller.
class FileLocationsController; def rescue_action(e) raise e end; end

class FileLocationsControllerTest < Test::Unit::TestCase
  fixtures :file_locations

  def setup
    @controller = FileLocationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:file_locations)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:file_location)
    assert assigns(:file_location).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:file_location)
  end

  def test_create
    num_file_locations = FileLocation.count

    post :create, :file_location => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_file_locations + 1, FileLocation.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:file_location)
    assert assigns(:file_location).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil FileLocation.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      FileLocation.find(1)
    }
  end
end
