class HomeController < ApplicationController
    def index
    end

    def last_tournaments
        @tournaments = Tournament.where(private: false).order(created_at: :desc).limit(15)
    end

    def my_tournaments
        @my_tournaments = Tournament.where(creator_id: current_user.id).order(created_at: :desc)
        @editable_tournaments = current_user.editable_tournaments
    end
end
