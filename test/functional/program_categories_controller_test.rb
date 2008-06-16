require 'test_helper'

class ProgramCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:program_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_program_category
    assert_difference('ProgramCategory.count') do
      post :create, :program_category => { }
    end

    assert_redirected_to program_category_path(assigns(:program_category))
  end

  def test_should_show_program_category
    get :show, :id => program_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => program_categories(:one).id
    assert_response :success
  end

  def test_should_update_program_category
    put :update, :id => program_categories(:one).id, :program_category => { }
    assert_redirected_to program_category_path(assigns(:program_category))
  end

  def test_should_destroy_program_category
    assert_difference('ProgramCategory.count', -1) do
      delete :destroy, :id => program_categories(:one).id
    end

    assert_redirected_to program_categories_path
  end
end
