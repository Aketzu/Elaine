require 'test_helper'

class TapesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:tapes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_tape
    assert_difference('Tape.count') do
      post :create, :tape => { }
    end

    assert_redirected_to tape_path(assigns(:tape))
  end

  def test_should_show_tape
    get :show, :id => tapes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => tapes(:one).id
    assert_response :success
  end

  def test_should_update_tape
    put :update, :id => tapes(:one).id, :tape => { }
    assert_redirected_to tape_path(assigns(:tape))
  end

  def test_should_destroy_tape
    assert_difference('Tape.count', -1) do
      delete :destroy, :id => tapes(:one).id
    end

    assert_redirected_to tapes_path
  end
end
