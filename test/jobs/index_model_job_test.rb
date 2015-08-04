require 'test_helper'
require 'minitest/mock'

class IndexModelJobTest < ActiveJob::TestCase
  fixtures :users,:categories
  #@note @rails mocking and stubbing with Minitest::Mock
  test 'when job is executed snippet is indexed by elastic search' do

    snippet= Snippet.new
    snippet.id = 1
    snippet.title="title"
    snippet.content="content"
    snippet.description="description"

    index_mock =  Minitest::Mock.new
    index_mock.expect(:call,nil,[
      index:snippet.class.elastic_search_index,
      type:snippet.class.elastic_search_type,
      id:snippet.id,
      body:snippet.to_elastic_search_body
    ])

    ElasticSearch.Client.stub(:index,index_mock) do
      IndexModelJob.perform_now(snippet)
    end
    index_mock.verify
  end
end
