require "test_helper"

class ActualitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @actualite = actualites(:one)
  end

  test "should get index" do
    get actualites_url
    assert_response :success
  end

  test "should get new" do
    get new_actualite_url
    assert_response :success
  end

  test "should create actualite" do
    assert_difference("Actualite.count") do
      post actualites_url, params: { actualite: { contenu: @actualite.contenu, image: @actualite.image, titre: @actualite.titre, user_id: @actualite.user_id } }
    end

    assert_redirected_to actualite_url(Actualite.last)
  end

  test "should show actualite" do
    get actualite_url(@actualite)
    assert_response :success
  end

  test "should get edit" do
    get edit_actualite_url(@actualite)
    assert_response :success
  end

  test "should update actualite" do
    patch actualite_url(@actualite), params: { actualite: { contenu: @actualite.contenu, image: @actualite.image, titre: @actualite.titre, user_id: @actualite.user_id } }
    assert_redirected_to actualite_url(@actualite)
  end

  test "should destroy actualite" do
    assert_difference("Actualite.count", -1) do
      delete actualite_url(@actualite)
    end

    assert_redirected_to actualites_url
  end
end
