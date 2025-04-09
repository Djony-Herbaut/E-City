require "application_system_test_case"

class ActualitesTest < ApplicationSystemTestCase
  setup do
    @actualite = actualites(:one)
  end

  test "visiting the index" do
    visit actualites_url
    assert_selector "h1", text: "Actualites"
  end

  test "should create actualite" do
    visit actualites_url
    click_on "New actualite"

    fill_in "Contenu", with: @actualite.contenu
    fill_in "Image", with: @actualite.image
    fill_in "Titre", with: @actualite.titre
    fill_in "User", with: @actualite.user_id
    click_on "Create Actualite"

    assert_text "Actualite was successfully created"
    click_on "Back"
  end

  test "should update Actualite" do
    visit actualite_url(@actualite)
    click_on "Edit this actualite", match: :first

    fill_in "Contenu", with: @actualite.contenu
    fill_in "Image", with: @actualite.image
    fill_in "Titre", with: @actualite.titre
    fill_in "User", with: @actualite.user_id
    click_on "Update Actualite"

    assert_text "Actualite was successfully updated"
    click_on "Back"
  end

  test "should destroy Actualite" do
    visit actualite_url(@actualite)
    click_on "Destroy this actualite", match: :first

    assert_text "Actualite was successfully destroyed"
  end
end
