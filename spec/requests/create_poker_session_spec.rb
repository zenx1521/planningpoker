require 'rails_helper'

describe "create new voting session", :type => :request do
  let(:user) {User.create!(:name => "Jan", :surname => "Kowalski")}

  it 'creates poker session and sets number_of_voting to 4' do
    post '/api/v1/poker_sessions', params: {:number_of_voting => 4,:token => user.token}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('SUCCESS')
    expect(JSON.parse(response.body,object_class: OpenStruct).data.number_of_voting).to eq(4)
  end 

  it 'returs USER_NOT_FOUND error if there is a wrong token' do
    post '/api/v1/poker_sessions', params: {:number_of_voting => 4,:token => "123456789"}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('ERROR')
    expect(JSON.parse(response.body, object_class: OpenStruct).error).to eq('USER_NOT_FOUND')
  end
  
  it 'returs SESSION_NOT_SAVED error if there is no number of voting' do
    post '/api/v1/poker_sessions', params: {:token => user.token}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('ERROR')
    expect(JSON.parse(response.body, object_class: OpenStruct).error).to eq('SESSION_NOT_SAVED')
  end 

  it 'returs SESSION_NOT_SAVED error if there is wrong number of voting' do
    post '/api/v1/poker_sessions', params: {:number_of_voting => "aaa",:token => user.token}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('ERROR')
    expect(JSON.parse(response.body, object_class: OpenStruct).error).to eq('SESSION_NOT_SAVED')
  end
end
