Geocoder.configure(
  lookup: :nominatim, # OpenStreetMap API
  http_headers: { "User-Agent" => "MyWeatherApp" }
)