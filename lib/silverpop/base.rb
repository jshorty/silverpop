require 'logger' 

module Silverpop

  class Base

    extend Forwardable
    
    def_delegators :'self.class', :url, :ftp_url, :ftp_port, :logger
    def_delegators :'self.class', :username, :password, :ftp_username, :ftp_password

    class << self

      def setup_urls(pod)
        Engage.url = "https://api#{pod}.silverpop.com/XMLAPI"
        Engage.ftp_url = "transfer#{pod}.silverpop.com"

        Transact.url = "https://transact#{pod}.silverpop.com/XTMail"
        Transact.ftp_url = "transfer#{pod}.silverpop.com"
      end

      def engage_username=(username)
        Engage.username = username
      end

      def engage_password=(password)
        Engage.password = password
      end

      def engage_ftp_username=(username)
        Engage.ftp_username = username
      end

      def engage_ftp_password=(password)
        Engage.ftp_password = password
      end

      def transact_username=(username)
        Transact.username = username
      end

      def transact_password=(password)
        Transact.password = password
      end

      def logger
        @@logger ||= Logger.new(STDOUT, 'weekly')
      end

      def logger=(logger)
        @@logger = logger
      end

      def configure
        yield(self)
      end
    end

    def query(xml, session_encoding='')
      u = URI.parse url
      http, resp    = Net::HTTP.new(u.host, u.port), ''
      http.use_ssl  = true
      http.start do |http|
        path = u.path + session_encoding
        resp = http.post path, xml, {'Content-type' => 'text/xml'}
      end
      resp.body
    end

    def strip_cdata string
      string.sub('<![CDATA[', '').sub(']]>', '')
    end

  end

end