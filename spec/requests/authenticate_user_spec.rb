require 'rails_helper'

describe "authenticate user", :type => :request do
  let(:user) {User.create!(:name => "Jan", :surname => "Kowalski")}

  it 'returns SUCCESS status if user was found' do
    post '/api/v1/users/authenticate', params: {:token => user.token}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('SUCCESS')
  end 

  it 'returns USER_NOT_FOUND error if there is no user with such token' do
    post '/api/v1/users/authenticate', params: {:token => "123456789"}
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('ERROR')
    expect(JSON.parse(response.body, object_class: OpenStruct).error).to eq('USER_NOT_FOUND')
  end 

  it 'returns USER_NOT_FOUND error if there is no token' do
    post '/api/v1/users/authenticate'
    expect(JSON.parse(response.body, object_class: OpenStruct).status).to eq('ERROR')
    expect(JSON.parse(response.body, object_class: OpenStruct).error).to eq('USER_NOT_FOUND')
  end 
end
