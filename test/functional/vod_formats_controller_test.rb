require 'test_helper'

class VodFormatsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vod_formats)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vod_format
    assert_difference('VodFormat.count') do
      post :create, :vod_format => { }
    end

    assert_redirected_to vod_format_path(assigns(:vod_format))
  end

  def test_should_show_vod_format
    get :show, :id => vod_formats(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vod_formats(:one).id
    assert_response :success
  end

  def test_should_update_vod_format
    put :update, :id => vod_formats(:one).id, :vod_format => { }
    assert_redirected_to vod_format_path(assigns(:vod_format))
  end

  def test_should_destroy_vod_format
    assert_difference('VodFormat.count', -1) do
      delete :destroy, :id => vod_formats(:one).id
    end

    assert_redirected_to vod_formats_path
  end
end
