# lib/messages.rb

# Contains messages
module Msg
  NO_LEGAL_MOVES = CLI::UI.fmt "{{red:No legal moves available from that square!}}"
  VICTORY = 'won! Congratulations!'
  TITLE = "
 ██████ ██   ██ ███████ ███████ ███████
██      ██   ██ ██      ██      ██
██      ███████ █████   ███████ ███████
██      ██   ██ ██           ██      ██
 ██████ ██   ██ ███████ ███████ ███████\n\n"
end
