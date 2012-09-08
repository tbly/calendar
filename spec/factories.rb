FactoryGirl.define do
  factory :movie do
    title "Test Movie"
    cs_id 12345
  end

  factory :showtime do
    movie
    theater

    playing_at DateTime.new( 2012, 7, 4, 15, 30 )
    playing_on Date.new( 2012, 7,4 )
    link       'https://www.movietickets.com/purchase.asp?afid=icnow&house_id=5010&movie_id=105933&perft=12:45&perfd=08182012'
    bargain    true
    passes     true
    festival   true
  end

  factory :theater do
    cs_id      23456
    name       'Test  Theater'
    address    '123   Test  Rd'
    city       'Testburg'
    state      'CA'
    zip        '90210'
    phone      '123-456-7890'
    county     'Test  County'
    ticketing  true
  end

  factory :user do
    username 'joe'
    email    'joe@mail.com'
    password 'password'
  end

  factory :local_news_article do
    title         'Test Article'
    url           'http://www.testurl.com/articles/page.html'
    author        'John Doe'
    content       'This is the test content for the test article.'
    guid          'http:://www.testurl.com/some_guid?p=123456'
    published_at  DateTime.new( 2012, 7, 30, 14, )
  end

  factory :local_news_categorization do
    association :local_news_article
    association :local_news_category
  end

  factory :local_news_category do
    name 'Test Category'
  end

  factory :local_news_listing do
    association :local_news_article
    association :local_news_source
  end

  factory :local_news_source do
    title    'Test Source'
    url      'http://www.testurl.com'
    feed_url 'http://www.testurl.com/feed/topic.rss'
    etag     'abcdef1234567890'
  end
end
