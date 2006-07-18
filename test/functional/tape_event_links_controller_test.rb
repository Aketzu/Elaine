require File.dirname(__FILE__) + '/../test_helper'
require 'tape_event_links_controller'

# Re-raise errors caught by the controller.
class TapeEventLinksController; def rescue_action(e) raise e end; end

class TapeEventLinksControllerTest < Test::Unit::TestCase
  fixtures :tape_event_links

  def setup
    @controller = TapeEventLinksController.new
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

    assert_not_nil assigns(:tape_event_links)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:tape_event_link)
    assert assigns(:tape_event_link).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:tape_event_link)
  end

  def test_create
    num_tape_event_links = TapeEventLink.count

    post :create, :tape_event_link => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_tape_event_links + 1, TapeEventLink.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tape_event_link)
    assert assigns(:tape_event_link).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil TapeEventLink.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TapeEventLink.find(1)
    }
  end
end
