require 'rails_helper'

describe "create a new vote", :type => :request do
  let(:user) {User.create!(:name => "Jan", :surname => "Kowalski")}
  let(:users) {FactoryBot.create_list(:user, 4)}
  let(:session) {user.poker_sessions.create(:number_of_voting => 4)}

  it 'returns SUCCESS status' do
    post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:token => user.token,:poker_session_id => session.id,:value => 3}

    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq("SUCCESS")
  end

  it 'returns ALREADY_VOTED error' do
    post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:token => user.token,:poker_session_id => session.id,:value => 3}
    post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:token => user.token,:poker_session_id => session.id,:value => 3}
  
    expect(JSON.parse(response.body, object_class: OpenStruct).errors.include? "ALREADY_VOTED").to eq(true)
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq("ERROR")
  end

  it 'returns SESSION_FINISHED error' do
    users.each do |user|
      post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:value => 5, :token => user.token}
    end

    post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:value => 5, :token => user.token}

    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq("ERROR")
    expect(JSON.parse(response.body, object_class: OpenStruct).errors.include? "SESSION_FINISHED").to eq(true)
  end
end
