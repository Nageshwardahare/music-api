class MusicbrainzService
  include HTTParty
  base_uri "https://musicbrainz.org/ws/2"

  # Set the User-Agent header to identify your app
  headers "User-Agent" => "MusicApp/1.0 (nageshwardahare7@gmail.com)"


  def initialize(city)
    @city = city
  end

  def fetch_recent_bands
    area_id = fetch_area_id
    return [] unless area_id

    fetch_bands_by_area(area_id)
  end

  private

  def fetch_area_id
    response = self.class.get("/area/", query: { query: @city, fmt: "json" })
    return nil unless response.success?
    response.parsed_response.dig("areas", 0, "id")
  end

  def fetch_bands_by_area(area_id)
    response = self.class.get("/artist/", query: { area: area_id, fmt: "json", limit: 100 })
    return [] unless response.success?

    ten_years_ago = Date.current.year - 10

    response.parsed_response["artists"].select do |artist|
      next unless artist["type"] == "Group"

      begin_year = artist.dig("life-span", "begin")
      begin_year && begin_year.to_i >= ten_years_ago
    end.first(50)
  end
end
