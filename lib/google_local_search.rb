%w(uri net/http json cgi).each { |lib| require lib }

module GoogleLocalSearch
  
  class GeoCode
  
    GOOGLE_URL = "http://www.google.com/uds/GlocalSearch?"
    
    class NoMatchFound < StandardError; end
    
    class Location < Struct.new(:lat, :lng); end
  
    class << self
      def locate(address)
        options = { "rsz" => "small", "v" => "1.0" }
        options.merge!("q" => CGI.escape(address))
        response = Net::HTTP.get_response(URI.parse(GOOGLE_URL + options.map { |k,v| "#{k}=#{v}" }.join("&")))
        if response.is_a?(Net::HTTPSuccess)
          result = JSON.parse(response.body)
          raise NoMatchFound if result['responseData']['results'].empty?
          location = Location.new(result['responseData']['results'][0]['lat'], result['responseData']['results'][0]['lng'])
        else
          response.error!
        end
        
      end
    end
  
  end

end