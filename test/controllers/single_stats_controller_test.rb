require "test_helper"

class SingleStatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @single_stat = single_stats(:one)
  end

  test "should get index" do
    get single_stats_url
    assert_response :success
  end

  test "should get new" do
    get new_single_stat_url
    assert_response :success
  end

  test "should create single_stat" do
    assert_difference("SingleStat.count") do
      post single_stats_url, params: { single_stat: { assistant_id: @single_stat.assistant_id, game_id: @single_stat.game_id, minute: @single_stat.minute, player_id: @single_stat.player_id, team_id: @single_stat.team_id, stat_type: @single_stat.stat_type } }
    end

    assert_redirected_to single_stat_url(SingleStat.last)
  end

  test "should show single_stat" do
    get single_stat_url(@single_stat)
    assert_response :success
  end

  test "should get edit" do
    get edit_single_stat_url(@single_stat)
    assert_response :success
  end

  test "should update single_stat" do
    patch single_stat_url(@single_stat), params: { single_stat: { assistant_id: @single_stat.assistant_id, game_id: @single_stat.game_id, minute: @single_stat.minute, player_id: @single_stat.player_id, team_id: @single_stat.team_id, stat_type: @single_stat.stat_type } }
    assert_redirected_to single_stat_url(@single_stat)
  end

  test "should destroy single_stat" do
    assert_difference("SingleStat.count", -1) do
      delete single_stat_url(@single_stat)
    end

    assert_redirected_to single_stats_url
  end
end
