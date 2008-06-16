require 'test_helper'

class VodFilesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vod_files)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vod_file
    assert_difference('VodFile.count') do
      post :create, :vod_file => { }
    end

    assert_redirected_to vod_file_path(assigns(:vod_file))
  end

  def test_should_show_vod_file
    get :show, :id => vod_files(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vod_files(:one).id
    assert_response :success
  end

  def test_should_update_vod_file
    put :update, :id => vod_files(:one).id, :vod_file => { }
    assert_redirected_to vod_file_path(assigns(:vod_file))
  end

  def test_should_destroy_vod_file
    assert_difference('VodFile.count', -1) do
      delete :destroy, :id => vod_files(:one).id
    end

    assert_redirected_to vod_files_path
  end
end
