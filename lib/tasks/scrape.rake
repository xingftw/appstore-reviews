namespace :scrape do
  namespace :shopify do

    desc "Will sync all pages of the Shopify app store with the local database"
    task :all => :environment do
      Scraper::Shopify.fetchAllPages(true, true, true)
    end

    desc "Will sync first page of Shopify app store with the local database"
    task :first => :environment do
      Scraper::Shopify.fetchPage(1, true, true)
    end
  end
end