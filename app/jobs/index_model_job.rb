class IndexModelJob < ActiveJob::Base
  queue_as :default

  def perform(model)
    ElasticSearch.Client.index(
    index: model.class.elastic_search_index,
    type: model.class.elastic_search_type,
    id: model.id,
    body: model.to_elastic_search_body)
  end
end
