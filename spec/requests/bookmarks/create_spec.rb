require 'rails_helper'

describe 'POST /bookmarks' do

  # group scenarios with authenticated user into this context block
  context "Authenticated API key" do

    let!(:api_key) { ApiKey.create(bookmark_api_key: 'key', bookmark_api_token: 'token') }

    # 'scenario' is similar to 'it', use which you see fit
    scenario 'valid bookmarks attributes' do
      # send a POST request to /bookmarks, with these parameters
      # The controller will treat them as JSON 
      post '/bookmarks', params: {
        bookmark: { 
          title: 'Test Bookmark',
          url: "facebook.com"
        }
      }, headers: { 'X-api-key': api_key.bookmark_api_key, 'X-api-token': api_key.bookmark_api_token }

      # response should have a status 201 created
      expect(response.status).to eq 201

      json = JSON.parse(response.body).deep_symbolize_keys

      # check the value of the returned response hash
      expect(json[:url]).to eq('facebook.com')
      expect(json[:title]).to eq('Test Bookmark')

      # check the value of the returned response hash
      expect(json[:url]).to eq('facebook.com')
      expect(json[:title]).to eq('Test Bookmark')

      # 1 new bookmark record is created
      expect(Bookmark.count).to eq(1)

      # Optionally, you can check the latest record data
      expect(Bookmark.last.title).to eq('Test Bookmark')
    end

    scenario 'invalid bookmark attributes' do
      post '/bookmarks', params: {
        bookmark: {
          url: '',
          title: 'RubyYagi blog'
        }
      }, headers: { 'X-api-key': api_key.bookmark_api_key, 'X-api-token': api_key.bookmark_api_token }

      # response should have HTTP Status 201 Created
      expect(response.status).to eq(422)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:url]).to eq(["can't be blank"])

      # no new bookmark record is created
      expect(Bookmark.count).to eq(0)
    end
  end

  # scenario with unauthenticated user
  context 'unauthenticated api key' do
    it 'should return forbidden error' do
      post '/bookmarks', params: {
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
