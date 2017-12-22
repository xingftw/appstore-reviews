require 'nokogiri'
require 'open-uri'

class FetchController < ApplicationController

  APPSTORE_NAME = 'Shopify'
  SHOPIFY_APPSTORE_URL = 'https://apps.shopify.com/smile-io'

  def shopify
    @reviews = []
    shouldSave = true
    page = params[:page] ||= 1
    fetchUrl = SHOPIFY_APPSTORE_URL + "?page=#{page}#reviews"
    document = Nokogiri::HTML(open(fetchUrl))

    reviewsSection = document.search('[id=reviews]')
    reviewElements = reviewsSection.search('[itemprop=review]')

    reviewElements.each do |reviewElement|
      externalId = reviewElement['data-review_id']
      review = Review.find_by_external_id(externalId)
      if review.nil?
        logger.debug "Review #{externalId} not found in DB. Creating a new one."
        review = Review.new
        review.external_id = externalId
      end

      ratingElement = reviewElement.search('[itemprop=reviewRating]').last
      review.rating = ratingElement['content']

      datePublishedElement = reviewElement.search('[itemprop=datePublished]').last
      review.published_at = DateTime.rfc3339(datePublishedElement['content'])

      reviewBodyElement = reviewElement.search('[itemprop=reviewBody]').last
      review.body = reviewBodyElement.text

      authorElement = reviewElement.search('[itemprop=author]').last
      review.shop_url = authorElement['href']
      review.shop_name = authorElement.text

      review.appstore = APPSTORE_NAME

      if shouldSave
        review.save
      end

      @reviews.push(review);
    end
  end
end
