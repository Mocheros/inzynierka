require "application_system_test_case"

class LineupsTest < ApplicationSystemTestCase
  setup do
    @lineup = lineups(:one)
  end

  test "visiting the index" do
    visit lineups_url
    assert_selector "h1", text: "Lineups"
  end

  test "should create lineup" do
    visit lineups_url
    click_on "New lineup"

    fill_in "Game", with: @lineup.game_id
    fill_in "Player", with: @lineup.player_id
    fill_in "Team", with: @lineup.team_id
    fill_in "Type", with: @lineup.type
    click_on "Create Lineup"

    assert_text "Lineup was successfully created"
    click_on "Back"
  end

  test "should update Lineup" do
    visit lineup_url(@lineup)
    click_on "Edit this lineup", match: :first

    fill_in "Game", with: @lineup.game_id
    fill_in "Player", with: @lineup.player_id
    fill_in "Team", with: @lineup.team_id
    fill_in "Type", with: @lineup.type
    click_on "Update Lineup"

    assert_text "Lineup was successfully updated"
    click_on "Back"
  end

  test "should destroy Lineup" do
    visit lineup_url(@lineup)
    click_on "Destroy this lineup", match: :first

    assert_text "Lineup was successfully destroyed"
  end
end
