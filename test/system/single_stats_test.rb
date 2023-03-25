require "application_system_test_case"

class SingleStatsTest < ApplicationSystemTestCase
  setup do
    @single_stat = single_stats(:one)
  end

  test "visiting the index" do
    visit single_stats_url
    assert_selector "h1", text: "Single stats"
  end

  test "should create single stat" do
    visit single_stats_url
    click_on "New single stat"

    fill_in "Assistent", with: @single_stat.assistant_id
    fill_in "Game", with: @single_stat.game_id
    fill_in "Minute", with: @single_stat.minute
    fill_in "Player", with: @single_stat.player_id
    fill_in "Team", with: @single_stat.team_id
    fill_in "Type", with: @single_stat.stat_type
    click_on "Create Single stat"

    assert_text "Single stat was successfully created"
    click_on "Back"
  end

  test "should update Single stat" do
    visit single_stat_url(@single_stat)
    click_on "Edit this single stat", match: :first

    fill_in "Assistent", with: @single_stat.assistant_id
    fill_in "Game", with: @single_stat.game_id
    fill_in "Minute", with: @single_stat.minute
    fill_in "Player", with: @single_stat.player_id
    fill_in "Team", with: @single_stat.team_id
    fill_in "Type", with: @single_stat.stat_type
    click_on "Update Single stat"

    assert_text "Single stat was successfully updated"
    click_on "Back"
  end

  test "should destroy Single stat" do
    visit single_stat_url(@single_stat)
    click_on "Destroy this single stat", match: :first

    assert_text "Single stat was successfully destroyed"
  end
end
