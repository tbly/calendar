require "spec_helper"

describe MoviesController do
  describe "routing" do
    it "routes to #index" do
      get("/movies").should route_to("movies#index")
    end

    it "routes to #show" do
      get("/movies/1").should route_to("movies#show", :id => "1")
    end
  end
end
