require 'rails_helper'

describe "create new voting session", :type => :request do
  let(:user) {User.create!(:name => "Jan", :surname => "Kowalski")}
  let(:users) {FactoryBot.create_list(:user, 4)}
  let(:session) {user.poker_sessions.create(:number_of_voting => 4)}

  it 'returns SUCCESS status' do
    session.votes.create(:value => 5, :user_id => 1)
    post '/api/v1/poker_sessions/' + session.id.to_s + '/reset_session', params: {:token => user.token}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq("SUCCESS")
  end 

  it 'contains unfinished session' do
    post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:value => 5, :token => user.token}
    post '/api/v1/poker_sessions/' + session.id.to_s + '/reset_session', params: {:token => user.token}
    expect(JSON.parse(response.body, object_class: OpenStruct).data.finished).to eq(false)
  end 

  it 'contains reseted session status' do
    users.each do |user|
      post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:value => 5, :token => user.token}
    end

    post '/api/v1/poker_sessions/' + session.id.to_s + '/reset_session', params: {:token => user.token}
    expect(JSON.parse(response.body, object_class: OpenStruct).data.finished).to eq(false)
  end 

  it 'returns ACCESS_DENIED error' do
    post '/api/v1/poker_sessions/' + session.id.to_s + '/reset_session', params: {:token => "123456789"}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('ERROR')
    expect(JSON.parse(response.body, object_class: OpenStruct).error).to eq('ACCESS_DENIED')
  end 
end
