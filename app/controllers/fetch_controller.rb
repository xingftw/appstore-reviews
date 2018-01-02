require 'nokogiri'
require 'open-uri'

class FetchController < ApplicationController


  def shopify
    shouldSave = params[:save] ||= ''
    if shouldSave.downcase == 'false' || shouldSave == '0'
      shouldSave = false
    else
      shouldSave = true
    end

    shouldLookupAccount = params[:account_lookup] ||= ''
    if shouldLookupAccount.downcase == 'false' || shouldLookupAccount == '0'
      shouldLookupAccount = false
    else
      shouldLookupAccount = true
    end

    page = params[:page] ||= 1
    reviews = Scraper::Shopify.fetchPage(page, shouldLookupAccount, shouldSave)

    render json: reviews
  end

end
