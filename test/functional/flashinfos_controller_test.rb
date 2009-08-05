require 'test_helper'

class FlashinfosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:flashinfos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_flashinfos
    assert_difference('Flashinfos.count') do
      post :create, :flashinfos => { }
    end

    assert_redirected_to flashinfos_path(assigns(:flashinfos))
  end

  def test_should_show_flashinfos
    get :show, :id => flashinfos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => flashinfos(:one).id
    assert_response :success
  end

  def test_should_update_flashinfos
    put :update, :id => flashinfos(:one).id, :flashinfos => { }
    assert_redirected_to flashinfos_path(assigns(:flashinfos))
  end

  def test_should_destroy_flashinfos
    assert_difference('Flashinfos.count', -1) do
      delete :destroy, :id => flashinfos(:one).id
    end

    assert_redirected_to flashinfos_path
  end
end
