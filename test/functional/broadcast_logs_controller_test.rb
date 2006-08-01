require File.dirname(__FILE__) + '/../test_helper'
require 'broadcast_logs_controller'

# Re-raise errors caught by the controller.
class BroadcastLogsController; def rescue_action(e) raise e end; end

class BroadcastLogsControllerTest < Test::Unit::TestCase
  fixtures :broadcast_logs

  def setup
    @controller = BroadcastLogsController.new
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

    assert_not_nil assigns(:broadcast_logs)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:broadcast_log)
    assert assigns(:broadcast_log).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:broadcast_log)
  end

  def test_create
    num_broadcast_logs = BroadcastLog.count

    post :create, :broadcast_log => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_broadcast_logs + 1, BroadcastLog.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:broadcast_log)
    assert assigns(:broadcast_log).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil BroadcastLog.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      BroadcastLog.find(1)
    }
  end
end
