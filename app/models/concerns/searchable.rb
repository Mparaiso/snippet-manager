
# ElalistSearch management
module ElasticSearch
  def self.Client(host: Rails.configuration.x.elasticsearch.client_host , log: Rails.env == 'test' ? false : true ) 
    @@client ||=Elasticsearch::Client.new log: log,
      host: host
  end
end

module Searchable

  extend ActiveSupport::Concern

  included do |model|

    # persist a searchable model
    after_save do |object|
      if not @@elastic_search_attributes.nil?
        body = {}
        @@elastic_search_attributes.each do |attr|
          if object.respond_to? attr
            body[attr] =  object.send(attr)
          end
        end
        ElasticSearch.Client(log:true).index index: @@elastic_search_index,
          type: model.elastic_search_type,
          id: object.id,
          body: body
      end
    end
    
    # class methods 

    def self.elastic_search_type
      self.to_s.downcase.parameterize.underscore
    end
    # elastic_search_index sets the index to use with elastic search
    def self.elastic_search_index(index)
      @@elastic_search_index = index
    end
  
    # elastic_search_attributes sets the attributes to persist in the document
    def self.elastic_search_attributes(*attributes)
      @@elastic_search_attributes = *attributes
    end

    # clean_up_elastic_search cleans up documents after testing
    def self.clean_up_elastic_search
      delete_type index: @@elastic_search_index, type: elastic_search_type 
    end

    def self.search_by(type, query)
      self.search("#{type}:#{query}")
    end

    private 
    # delete_type deletes all documents from a given type in a given index
    def self.delete_type(index:nil,type:nil)
      ElasticSearch.Client.perform_request :delete,"#{index}/#{type}"
    end

  
  end

end
