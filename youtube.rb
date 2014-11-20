require 'rubygems'
require 'google/api_client'
require 'trollop'

def get_url(movie)
# Set developer_key to the "API key" value from the "Access" tab of the
# Google Developers Console <https://cloud.google.com/console>
# Please ensure that you have enabled the YouTube Data API for your project.
  developer_key = "AIzaSyD7A3DCqncxjp-uvNS0dbU9ZNSOJEJL3uc"
  youtube_api_service_name = "youtube"
  youtube_api_version = "v3"

  opts = Trollop::options do
    opt :q, movie, :type => String, :default => "#{movie} trailer"
    opt :maxResults, 'Max results', :type => :int, :default => 25
  end

  client = Google::APIClient.new(:key => developer_key,
  :authorization => nil)
  youtube = client.discovered_api(youtube_api_service_name, youtube_api_version)

  # Call the search.list method to retrieve results matching the specified
  # query term.
  opts[:part] = 'id,snippet'
  search_response = client.execute!(
  :api_method => youtube.search.list,
  :parameters => opts
  )

  videos = []
  channels = []
  playlists = []

  # Add each result to the appropriate list, and then display the lists of
  # matching videos, channels, and playlists.
  search_response.data.items.each do |search_result|
    case search_result.id.kind
    when 'youtube#video'
      videos.push("#{search_result.snippet.title} (#{search_result.id.videoId})")
    when 'youtube#channel'
      channels.push("#{search_result.snippet.title} (#{search_result.id.channelId})")
    when 'youtube#playlist'
      playlists.push("#{search_result.snippet.title} (#{search_result.id.playlistId})")
    end
  end

  # puts opts
  video_id = videos[0][(videos[0].length-12)...(videos[0].length-1)]

  url = "//youtube.com/embed/#{video_id}"
  url
end
