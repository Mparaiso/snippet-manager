
# ElalistSearch management
module ElasticSearch
  def self.Client(host: Rails.configuration.x.elasticsearch.client_host ,
    log: Rails.env == 'test' ? false : true )
    @@client ||=Elasticsearch::Client.new log: log,
    host: host
  end
end

# make a model searchable
module Searchable

  extend ActiveSupport::Concern

  included do
    # persist a searchable model
    after_save do |model|
      IndexModelJob.perform_later(model)
    end

    # to_elastic_search_body filter attributes that need to be persisted in elastic search
    def to_elastic_search_body
      if not @@elastic_search_attributes.nil?
        body = {}
        @@elastic_search_attributes.each do |attr|
          if self.respond_to? attr
            body[attr] =  self.send(attr)
          end
        end
        body
      else
        self
      end
    end
   
    # returns the type of the document in elastic search index
    def self.elastic_search_type
      self.to_s.downcase.parameterize.underscore
    end

    # elastic_search_index sets the index to use with elastic search
    def self.elastic_search_index(index=nil)
      if index.nil?
        @@elastic_search_index
      else
        @@elastic_search_index = index.to_s
      end
    end

    # elastic_search_attributes sets the attributes to persist in the document
    def self.elastic_search_attributes(*attributes)
      @@elastic_search_attributes = *attributes
    end

    # clean_up_elastic_search cleans up documents after testing
    def self.clean_up_elastic_search
      ElasticSearch.Client.delete_by_query index: @@elastic_search_index,
      type: elastic_search_type ,
      body:{query:{match_all:{}}}
    end

    def self.search_by(type, query)
      ElasticSearch.Client.search("#{type}:#{query}")
    end
  end
end
