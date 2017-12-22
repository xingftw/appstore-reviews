class FetchController < ApplicationController

  SHOPIFY_APPSTORE_URL = 'https://apps.shopify.com/smile-io'

  def shopify
    page = params[:page] ||= 1
    @fetchUrl = SHOPIFY_APPSTORE_URL << "?page=#{page}#reviews"
  end
end
