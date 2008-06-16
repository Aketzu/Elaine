require 'test_helper'

class ProgramDescriptionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:program_descriptions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_program_description
    assert_difference('ProgramDescription.count') do
      post :create, :program_description => { }
    end

    assert_redirected_to program_description_path(assigns(:program_description))
  end

  def test_should_show_program_description
    get :show, :id => program_descriptions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => program_descriptions(:one).id
    assert_response :success
  end

  def test_should_update_program_description
    put :update, :id => program_descriptions(:one).id, :program_description => { }
    assert_redirected_to program_description_path(assigns(:program_description))
  end

  def test_should_destroy_program_description
    assert_difference('ProgramDescription.count', -1) do
      delete :destroy, :id => program_descriptions(:one).id
    end

    assert_redirected_to program_descriptions_path
  end
end
