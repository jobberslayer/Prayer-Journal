class SearchController < ApplicationController
  def search_for
    @search_text = params[:search]
  end
end
