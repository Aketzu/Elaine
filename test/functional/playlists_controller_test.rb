require File.dirname(__FILE__) + '/../test_helper'
require 'playlists_controller'

# Re-raise errors caught by the controller.
class PlaylistsController; def rescue_action(e) raise e end; end

class PlaylistsControllerTest < Test::Unit::TestCase
  fixtures :playlists

  def setup
    @controller = PlaylistsController.new
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

    assert_not_nil assigns(:playlists)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:playlist)
    assert assigns(:playlist).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:playlist)
  end

  def test_create
    num_playlists = Playlist.count

    post :create, :playlist => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_playlists + 1, Playlist.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:playlist)
    assert assigns(:playlist).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Playlist.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Playlist.find(1)
    }
  end
end
