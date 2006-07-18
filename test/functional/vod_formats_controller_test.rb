require File.dirname(__FILE__) + '/../test_helper'
require 'vod_formats_controller'

# Re-raise errors caught by the controller.
class VodFormatsController; def rescue_action(e) raise e end; end

class VodFormatsControllerTest < Test::Unit::TestCase
  fixtures :vod_formats

  def setup
    @controller = VodFormatsController.new
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

    assert_not_nil assigns(:vod_formats)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:vod_format)
    assert assigns(:vod_format).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:vod_format)
  end

  def test_create
    num_vod_formats = VodFormat.count

    post :create, :vod_format => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_vod_formats + 1, VodFormat.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:vod_format)
    assert assigns(:vod_format).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil VodFormat.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      VodFormat.find(1)
    }
  end
end
