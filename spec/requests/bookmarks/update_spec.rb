require 'rails_helper'

describe 'PUT /bookmarks' do

  # group scenarios with authenticated user into this context block
  context "Authenticated API key" do
    let!(:api_key) { ApiKey.create(bookmark_api_key: 'key', bookmark_api_token: 'token') }

    # this will create a 'bookmark' method, which return the created bookmark object, 
    # before each scenario is ran
    let!(:bookmark) { Bookmark.create(title: 'test title', url: 'facebook.com') }

    scenario 'valid bookmark attributes' do
      # send put request to /bookmarks/:id
      put "/bookmarks/#{bookmark.id}", params: {
        bookmark: {
          url: 'https://fluffy.es',
          title: 'Fluffy'
        }
      }, headers: { 'X-api-key': api_key.bookmark_api_key, 'X-api-token': api_key.bookmark_api_token }

      # response should have HTTP Status 200 OK
      expect(response.status).to eq(200)

      # response should contain JSON of the updated object
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:url]).to eq('https://fluffy.es')
      expect(json[:title]).to eq('Fluffy')

      # The bookmark title and url should be updated
      expect(bookmark.reload.title).to eq('Fluffy')
      expect(bookmark.reload.url).to eq('https://fluffy.es')
    end

    scenario 'invalid bookmark attributes' do
      # send put request to /bookmarks/:id
      put "/bookmarks/#{bookmark.id}", params: {
        bookmark: {
          url: '',
          title: 'Fluffy'
        }
      }, headers: { 'X-api-key': api_key.bookmark_api_key, 'X-api-token': api_key.bookmark_api_token }

      # response should have HTTP Status 422 Unprocessable entity
      expect(response.status).to eq(422)

      # response should contain error message
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:url]).to eq(["can't be blank"])

      # The bookmark title and url remain unchanged
      expect(bookmark.reload.title).to eq('test title')
      expect(bookmark.reload.url).to eq('facebook.com')
    end
  end

   # scenario with unauthenticated user
  context 'unauthenticated api key' do
    let!(:bookmark) { Bookmark.create(title: 'test title', url: 'facebook.com') }
    
    it 'should return forbidden error' do
      put "/bookmarks/#{bookmark.id}", params: {
        bookmark: {
          url: 'https://rubyyagi.com',
          title: 'RubyYagi blog'
        }
      }

      # response should have HTTP Status 403 Forbidden
      expect(response.status).to eq(403)
      
      # response contain error message
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq('Invalid API key')
    end
  end

end
