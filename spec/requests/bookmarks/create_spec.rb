require 'rails_helper'

describe 'POST /bookmarks' do
  # 'scenario' is similar to 'it', use which you see fit

  scenario 'valid bookmarks attributes' do
    # send a POST request to /bookmarks, with these parameters
    # The controller will treat them as JSON 
    post '/bookmarks', params: {
      bookmark: { 
        title: 'Test Bookmark',
        url: "facebook.com"
      }
    }

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
    }

    # response should have HTTP Status 201 Created
    expect(response.status).to eq(422)

    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq(["can't be blank"])

    # no new bookmark record is created
    expect(Bookmark.count).to eq(0)
  end
end
