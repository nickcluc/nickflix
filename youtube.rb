require 'rubygems'
gem 'google-api-client', '>0.7'
require 'google/api_client'
require 'trollop'
require 'pry'

# Set DEVELOPER_KEY to the API key value from the APIs & auth > Credentials
# tab of
# {{ Google Cloud Console }} <{{ https://cloud.google.com/console }}>
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = ENV["YOUTUBE_API_KEY"]
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
# binding.pry

def get_service
  client = Google::APIClient.new(
  :key => DEVELOPER_KEY,
  :authorization => nil,
  :application_name => 'NICKFLIX',
  :application_version => '0.0.1'
  )
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  return client, youtube
end

def get_url(movie)
  opts = Trollop::options do
    opt :q, '#{movie}', :type => String, :default => movie + 'trailer'
    opt :max_results, 'Max results', :type => :int, :default => 1
  end

  client, youtube = get_service

  begin
    # Call the search.list method to retrieve results matching the specified
    # query term.
    search_response = client.execute!(
    :api_method => youtube.search.list,
    :parameters => {
      :part => 'snippet',
      :q => opts[:q],
      :maxResults => opts[:max_results]
    }
    )

    videos = []
  # Add each result to the appropriate list, and then display the lists of
  # matching videos, channels, and playlists.
  search_response.data.items.each do |search_result|
    case search_result.id.kind
    when 'youtube#video'
      videos << "//youtube.com/embed/#{search_result.id.videoId}"
    end
  end
  url = videos[0]
  url
  end
end
