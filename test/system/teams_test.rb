require "application_system_test_case"

class TeamsTest < ApplicationSystemTestCase
  setup do
    @team = teams(:one)
  end

  test "visiting the index" do
    visit teams_url
    assert_selector "h1", text: "Teams"
  end

  test "should create team" do
    visit teams_url
    click_on "New team"

    fill_in "Defeats", with: @team.defeats
    fill_in "Draws", with: @team.draws
    fill_in "Games played", with: @team.games_played
    fill_in "Goals against", with: @team.goals_against
    fill_in "Goals for", with: @team.goals_for
    fill_in "Name", with: @team.name
    fill_in "Points", with: @team.points
    fill_in "Wins", with: @team.wins
    click_on "Create Team"

    assert_text "Team was successfully created"
    click_on "Back"
  end

  test "should update Team" do
    visit team_url(@team)
    click_on "Edit this team", match: :first

    fill_in "Defeats", with: @team.defeats
    fill_in "Draws", with: @team.draws
    fill_in "Games played", with: @team.games_played
    fill_in "Goals against", with: @team.goals_against
    fill_in "Goals for", with: @team.goals_for
    fill_in "Name", with: @team.name
    fill_in "Points", with: @team.points
    fill_in "Wins", with: @team.wins
    click_on "Update Team"

    assert_text "Team was successfully updated"
    click_on "Back"
  end

  test "should destroy Team" do
    visit team_url(@team)
    click_on "Destroy this team", match: :first

    assert_text "Team was successfully destroyed"
  end
end
