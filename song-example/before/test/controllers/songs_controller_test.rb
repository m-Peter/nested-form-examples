require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  setup do
    @song = songs(:lockdown)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:songs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create song" do
    assert_difference(['Song.count', 'Artist.count', 'Producer.count']) do
      post :create, song: {
        title: "Diamonds",
        length: "360",

        artist_attributes: {
          name: "Karras",

          producer_attributes: {
            name: "Phoebos",
            studio: "MADog"
          }
        }
      }
    end

    song = assigns(:song)

    assert_redirected_to song_path(song)
    assert_equal "Diamonds", song.title
    assert_equal "360", song.length
    assert_equal "Karras", song.artist.name
    assert_equal "Phoebos", song.artist.producer.name
    assert_equal "MADog", song.artist.producer.studio
    assert_equal "Song: Diamonds was successfully created.", flash[:notice]
  end

  test "should not create song with invalid params" do
    assert_difference(['Song.count', 'Artist.count', 'Producer.count'], 0) do
      post :create, song: {
        title: nil,
        length: nil,

        artist_attributes: {
          name: nil,

          producer_attributes: {
            name: nil,
            studio: nil
          }
        }
      }
    end

    song = assigns(:song)
    
    assert_not song.valid?
    
    assert_includes song.errors.messages[:title], "can't be blank"
    assert_includes song.errors.messages[:length], "can't be blank"
    assert_includes song.artist.errors.messages[:name], "can't be blank"
    assert_includes song.artist.producer.errors.messages[:name], "can't be blank"
    assert_includes song.artist.producer.errors.messages[:studio], "can't be blank"
  end

  test "should show song" do
    get :show, id: @song
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @song
    assert_response :success
  end

  test "should update song" do
    patch :update, id: @song, song: { length: @song.length, title: @song.title }
    assert_redirected_to song_path(assigns(:song))
  end

  test "should destroy song" do
    assert_difference('Song.count', -1) do
      delete :destroy, id: @song
    end

    assert_redirected_to songs_path
  end
end
