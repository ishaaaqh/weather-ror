require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherController, type: :controller do
  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe "GET #show" do
    let(:valid_address) { "New York" }
    let(:latitude) { 40.7128 }
    let(:longitude) { -74.0060 }
    let(:zip_code) { "10001" }
    let(:weather_response) do
      {
        main: { temp: 22.5, temp_max: 25.0, temp_min: 20.0 },
        weather: [{ description: "clear sky" }]
      }.to_json
    end

    before do

        geocoder_mock = instance_double("Geocoder::Result::Nominatim", 
                                      latitude: latitude, 
                                      longitude: longitude, 
                                      postal_code: zip_code)

        allow(Geocoder).to receive(:search).with(valid_address).and_return([geocoder_mock])
        
        stub_request(:get, /api.openweathermap.org/)
            .to_return(status: 200, body: weather_response, headers: { "Content-Type" => "application/json" })
    end

    context "when address is provided" do
      it "fetches weather data successfully" do
        get :show, params: { address: valid_address }
        expect(assigns(:weather)).to include(temp: 22.5, high: 25.0, low: 20.0, condition: "clear sky")
        expect(response).to have_http_status(:ok)
      end

      it "caches the weather data" do
        Rails.cache.clear
        expect(Rails.cache.read("weather_#{zip_code}")).to be_nil

        get :show, params: { address: valid_address }
        expect(Rails.cache.read("weather_#{zip_code}")).not_to be_nil
      end

      it "retrieves data from cache if available" do
        Rails.cache.write("weather_#{zip_code}", { temp: 22.5, high: 25.0, low: 20.0, condition: "clear sky" }, expires_in: 30.minutes)

        get :show, params: { address: valid_address }
        expect(assigns(:from_cache)).to be true
      end
    end

    context "when an invalid address is provided" do
      before do
        allow(Geocoder).to receive(:search).and_return([])
      end

      it "sets an error message" do
        get :show, params: { address: "InvalidCity" }
        expect(assigns(:error)).to eq("Please enter a valid city or zip code")
      end
    end
  end
end
