module Api::BaseHelper

  protected

  # paginated_array returns an hash of pagination informations for a given paginated_arry
  def app_paginator(paginated_array,per_page=20)
    {per_page:per_page,
     next_page: next_page_url(paginated_array),
     previous_page: previous_page_url(paginated_array),
     total_pages:paginated_array.total_pages,
     total_objects:paginated_array.total_count }
  end

  private
  # next_product_url generates a url from a paginated list of products
  # <ActiveRecord::Relation[<Product>]> => string
  def next_page_url(paginated_array)
    url_for(page: paginated_array.next_page)  unless paginated_array.last_page?
  end

  # previous_product_url generates a url from a paginated list of products
  # links to the previous product page
  # <ActiveRecord::Relation[<Product>]> => string
  def previous_page_url(paginated_array)

    url_for(page: paginated_array.prev_page)  unless paginated_array.first_page?

  end

end
