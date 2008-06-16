require 'test_helper'

class VodsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vods)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vod
    assert_difference('Vod.count') do
      post :create, :vod => { }
    end

    assert_redirected_to vod_path(assigns(:vod))
  end

  def test_should_show_vod
    get :show, :id => vods(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vods(:one).id
    assert_response :success
  end

  def test_should_update_vod
    put :update, :id => vods(:one).id, :vod => { }
    assert_redirected_to vod_path(assigns(:vod))
  end

  def test_should_destroy_vod
    assert_difference('Vod.count', -1) do
      delete :destroy, :id => vods(:one).id
    end

    assert_redirected_to vods_path
  end
end
