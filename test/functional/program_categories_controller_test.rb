require File.dirname(__FILE__) + '/../test_helper'
require 'program_categories_controller'

# Re-raise errors caught by the controller.
class ProgramCategoriesController; def rescue_action(e) raise e end; end

class ProgramCategoriesControllerTest < Test::Unit::TestCase
  fixtures :program_categories

  def setup
    @controller = ProgramCategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = program_categories(:first).id
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

    assert_not_nil assigns(:program_categories)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:program_category)
    assert assigns(:program_category).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:program_category)
  end

  def test_create
    num_program_categories = ProgramCategory.count

    post :create, :program_category => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_program_categories + 1, ProgramCategory.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:program_category)
    assert assigns(:program_category).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ProgramCategory.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ProgramCategory.find(@first_id)
    }
  end
end
