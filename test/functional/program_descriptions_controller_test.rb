require File.dirname(__FILE__) + '/../test_helper'
require 'program_descriptions_controller'

# Re-raise errors caught by the controller.
class ProgramDescriptionsController; def rescue_action(e) raise e end; end

class ProgramDescriptionsControllerTest < Test::Unit::TestCase
  fixtures :program_descriptions

  def setup
    @controller = ProgramDescriptionsController.new
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

    assert_not_nil assigns(:program_descriptions)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:program_descriptions)
    assert assigns(:program_descriptions).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:program_descriptions)
  end

  def test_create
    num_program_descriptions = ProgramDescriptions.count

    post :create, :program_descriptions => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_program_descriptions + 1, ProgramDescriptions.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:program_descriptions)
    assert assigns(:program_descriptions).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ProgramDescriptions.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ProgramDescriptions.find(1)
    }
  end
end
