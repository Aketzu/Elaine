require 'test_helper'

class ReferenceLogsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:reference_logs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_reference_log
    assert_difference('ReferenceLog.count') do
      post :create, :reference_log => { }
    end

    assert_redirected_to reference_log_path(assigns(:reference_log))
  end

  def test_should_show_reference_log
    get :show, :id => reference_logs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => reference_logs(:one).id
    assert_response :success
  end

  def test_should_update_reference_log
    put :update, :id => reference_logs(:one).id, :reference_log => { }
    assert_redirected_to reference_log_path(assigns(:reference_log))
  end

  def test_should_destroy_reference_log
    assert_difference('ReferenceLog.count', -1) do
      delete :destroy, :id => reference_logs(:one).id
    end

    assert_redirected_to reference_logs_path
  end
end
