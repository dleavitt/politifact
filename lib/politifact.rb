require "httparty"
require "hashie/mash"
require 'net-http-spy'

class Politifact
  include HTTParty
  
  BASE_URI = 'www.politifact.com'
  API_VERSION = '/api/v/2/'
  
  base_uri "#{BASE_URI}#{API_VERSION}"
  format :json
  
  def self.get_one(path, id, query = {}, options = {})
    options[:query] = (options[:query] || {}).merge(query)
    wrap_object(get("/#{path}/#{id}", options))
  end
  
  def self.get_all(path, query = {}, options = {})
    options[:query] = (options[:query] || {}).merge(query)
    Collection.paginate(get('/'+path, options))
  end
  
  def self.get(path, options)
    super(fix_path(path), options)
  end
  
  def self.wrap_object(object)
    Hashie::Mash.new(object)
  end
  
  def self.fix_path(path)
    path += "/" unless path[-1] == "/"
    path.gsub(API_VERSION, '')
  end
  
  class Collection < Array
    # Based on Koala::Facebook::API::GraphCollection
    attr_reader :meta, :raw_response
    
    def initialize(response)
      super(response["objects"].map { |obj| Politifact.wrap_object(obj) })
      @meta = response["meta"]
      @raw_response = response
    end
    
    def self.paginate(response)
      if response.is_a?(Hash) && response["objects"].is_a?(Array)
        self.new(response)
      else
        response.map { |obj| Politifact.wrap_object(obj) }
      end
    end
    
    def next_page?
      meta["next"]
    end
    
    def next_page
      path, params = parse_page_url(meta["next"])
      next_page? ? Politifact.get_all(path, params) : nil
    end
    
    def previous_page?
      meta["previous"]
    end
    
    def previous_page
      path,params = parse_page_url(meta["previous"])
      previous_page? ? Politifact.get_all(path, params) : nil
    end
    
    def parse_page_url(url)
      uri = URI.parse(url)
      query = CGI.parse(uri.query)
      [uri.path, query.merge(query) { |k, v| v[0] }]
    end
  end
  
  ENDPOINTS = [
    "campaign",
    "edition",
    "electionyear",
    "media",
    "mediatype",
    "party",
    "person",
    "promise",
    "promisegroup",
    "promiselist",
    "promiseruling",
    "publication",
    "rollingaverage",
    "rulingtally",
    "staffer",
    "statement",
    "statementlist",
    "statementruling",
    "statementtype",
    "story",
    "storylist",
    "subject",
    "subjectrulingtally",
    "subjecttally",
    "toppeople",
    "totaltally",
    "truthtrend",
    "update",
    "updatelist",
  ]
end