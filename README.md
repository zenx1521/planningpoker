Commands

ruby poker.rb start [number of people participating in poker session] - starts a poker session, id of session created is returned.
ruby poker.rb vote [vote's value] [id of poker session] - allows users to vote
ruby poker.rb reset [id of poker session] - allows to reset session(all previous votes are destroyed). Only owner of the session can do that. For example it can be used if there was
a draw during voting.

At the beginning of the program user has to login with his token. User can be created in rails console:

User(:name => name, :surname => surname)

Token will be generated automatically