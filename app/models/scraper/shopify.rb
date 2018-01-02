require "net/http"

class Scraper::Shopify

  APPSTORE_NAME = 'Shopify'
  APPSTORE_URL = 'https://apps.shopify.com/smile-io'

  # Will fetch reviews from all pages of the app store
  # Params:
  # +shouldLookupAccount+:: if true, will also look up matching Smile Account
  # +shouldSave+:: if true, will save the review to local database
  # +enableLog+:: if true, will use +puts+ statements to print progress to console
  def self.fetchAllPages(shouldLookupAccount, shouldSave, enableLog)
    reviews = []
    currentPage = 1
    while true do
      puts "Fetching page #{currentPage}..." if enableLog
      reviewsOfCurrentPage = fetchPage(currentPage, shouldLookupAccount, shouldSave)
      puts "\tFetched all on page #{currentPage}"  if enableLog
      reviewsOfCurrentPage.each do |review|
        reviews.push(review)
      end
      puts "\tStored all on page #{currentPage}\n" if enableLog
      currentPage += 1

      if reviewsOfCurrentPage.empty?
        break;
      end
    end

    reviews
  end

  # Will fetch reviews from a page in the app store
  # Params:
  # +page+:: page number to fetch reviews from.
  # +shouldLookupAccount+:: if true, will also look up matching Smile Account
  # +shouldSave+:: if true, will save the review to local database
  def self.fetchPage (page, shouldLookupAccount, shouldSave)
    reviews = []
    fetchUrl = APPSTORE_URL + "?page=#{page}#reviews"
    response = Net::HTTP.get_response(URI(fetchUrl)).body
    document = Nokogiri::HTML(response)

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