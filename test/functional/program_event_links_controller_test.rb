require File.dirname(__FILE__) + '/../test_helper'
require 'program_event_links_controller'

# Re-raise errors caught by the controller.
class ProgramEventLinksController; def rescue_action(e) raise e end; end

class ProgramEventLinksControllerTest < Test::Unit::TestCase
  fixtures :program_event_links

  def setup
    @controller = ProgramEventLinksController.new
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

    assert_not_nil assigns(:program_event_links)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:program_event_link)
    assert assigns(:program_event_link).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:program_event_link)
  end

  def test_create
    num_program_event_links = ProgramEventLink.count

    post :create, :program_event_link => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_program_event_links + 1, ProgramEventLink.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:program_event_link)
    assert assigns(:program_event_link).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ProgramEventLink.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ProgramEventLink.find(1)
    }
  end
end
