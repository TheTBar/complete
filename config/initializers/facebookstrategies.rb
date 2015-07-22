module OmniAuth
  module Strategies
    class Facebook < OAuth2

      def request_phase
        options[:scope] ||= "email,public_profile"
        options['info_fields'] = 'id,email,gender,link,locale,name,timezone,updated_time,verified'
        options[:display] = mobile_request? ? 'touch' : 'page'
        super
      end

      def mobile_request?
        ua = Rack::Request.new(@env).user_agent.to_s
        ua.downcase =~ Regexp.new(MOBILE_USER_AGENTS)
      end
    end
  end
end