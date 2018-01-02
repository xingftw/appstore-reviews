class Scraper::Shopify

  APPSTORE_NAME = 'Shopify'
  APPSTORE_URL = 'https://apps.shopify.com/smile-io'

  def self.fetchAllPages(shouldLookupAccount, shouldSave)
    reviews = []
    currentPage = 1
    while true do
      logger.debug "Fetching page #{currentPage}"
      reviewsOfCurrentPage = fetchPage(currentPage, shouldLookupAccount, shouldSave)
      logger.debug "Got all reviews in page #{currentPage}"
      reviewsOfCurrentPage.each do |review|
        reviews.push(review)
      end
      logger.debug "Done storing reviews in page #{currentPage}"
      currentPage += 1

      if reviewsOfCurrentPage.empty?
        break;
      end
    end

    reviews
  end


  def self.fetchPage (page, shouldLookupAccount, shouldSave)
    reviews = []
    fetchUrl = APPSTORE_URL + "?page=#{page}#reviews"
    document = Nokogiri::HTML(open(fetchUrl))

    reviewsSection = document.search('[id=reviews]')
    reviewElements = reviewsSection.search('[itemprop=review]')

    reviewElements.each do |reviewElement|
      externalId = reviewElement['data-review_id']
      review = Review.find_by_external_id(externalId)
      if (review.nil?)
        review = Review.new
        review.external_id = externalId
      end

      review.appstore = APPSTORE_NAME

      ratingElement = reviewElement.search('[itemprop=reviewRating]').last
      review.rating = ratingElement['content']

      datePublishedElement = reviewElement.search('[itemprop=datePublished]').last
      review.published_at = DateTime.rfc3339(datePublishedElement['content'])

      reviewBodyElement = reviewElement.search('[itemprop=reviewBody]').last
      review.body = reviewBodyElement.text

      authorElement = reviewElement.search('[itemprop=author]').last
      review.shop_url = authorElement['href']
      review.shop_name = authorElement.text

      if shouldLookupAccount && review.account_id.nil?
        channelExternalId = review.shop_url.sub('https://', '').sub('http://', '')
        channel = Channel::Shopify.find_by_external_id(channelExternalId)
        if !channel.nil?
          review.account_id = channel.account_id
        end
      end

      if shouldSave
        review.save
      end

      reviews.push(review)
    end

    reviews
  end
end