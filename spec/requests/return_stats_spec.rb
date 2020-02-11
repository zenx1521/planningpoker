require 'rails_helper'

describe "return statistics", :type => :request do
  let(:user) {User.create!(:name => "Jan", :surname => "Kowalski")}
  let(:users) {FactoryBot.create_list(:user, 4)}
  let(:session) {user.poker_sessions.create(:number_of_voting => 4)}

  it 'returns SUCCESS status' do
    get '/api/v1/poker_sessions/' + session.id.to_s + '/return_stats'
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('SUCCESS')
  end 

  it 'contains 1 vote' do
    session.votes.create(:value => 4,:user_id => 1)
    get '/api/v1/poker_sessions/' + session.id.to_s + '/return_stats'
    expect(JSON.parse(JSON.parse(response.body, object_class: OpenStruct).data,object_class:OpenStruct).votes.count).to eq(1)
  end 

  it 'returns finished session' do
    users.each do |user|
      post '/api/v1/poker_sessions/' + session.id.to_s + '/votes', params: {:value => 5, :token => user.token}
    end

    get '/api/v1/poker_sessions/' + session.id.to_s + '/return_stats'
    
    expect(JSON.parse(JSON.parse(response.body, object_class: OpenStruct).data,object_class:OpenStruct).finished).to eq(true)
  end 
end
