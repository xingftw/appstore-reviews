# AppStore Reviews Parser
## Overview
Simple Rails project deployed on Heroku that fetches and stores (Shopify) app store reviews in a database and retrieves them as JSON. It also matches reviews against internal Smile accounts.

## Usage
Application is deployed at https://appstore-reviews.herokuapp.com/
_You'll need Basic HTTP Authorization to access the end-points. Ask *Mohsen* for credentials._

### End-Point: [/fetch/shopify](https://appstore-reviews.herokuapp.com/fetch/shopify)
End-point will fetch a specific review page, match each review against a Smile account, store in the review in the database, and produce a JSON array of reviews on the specified page.
**GET Options:**
 * `page`: Page number to retrieve *(default = `1`)*
 * `save`: Boolean to enable/disable saving of fetched results in database *(default = `true`)*
 * `account_lookup`: Boolean to enable/disable lookup of smile accounts *(default = `true`)*
 
**Example URL:**
 * https://appstore-reviews.herokuapp.com/fetch/shopify?page=1&save=true&account_lookup=true

### End-Point: [/reviews](https://appstore-reviews.herokuapp.com/reviews)
End-point will retrieve all reviews store in the database (not the app-store!) and display as a JSON array. 

**Example URL:**
 * https://appstore-reviews.herokuapp.com/reviews

### End-Point: [/reviews/:id](https://appstore-reviews.herokuapp.com/reviews/:id)
End-point will retrieve a particular review from the database, specified by it's internal-id, and display as JSON.

**Example URL:**
 * https://appstore-reviews.herokuapp.com/reviews/1

### Task: `rake scrape:shopify:all`
Rake task will visit every review page of the app store listing, and save or update all reviews in the database.

**Scheduled:**
* This rake task is scheduled to run once every 24 hours automatically by Heroku.

## Setup Notes
* This app was built on Ruby 2.3.1 and Rails 5.1.4.
* Two postgres database connections are required:
    1. Local database storing a copy of the reviews
    2. Smile database (read-only)
* Database credentials + HTTP Basic Authentication credentials are stored in Environment Variables currently deployed to Heroku