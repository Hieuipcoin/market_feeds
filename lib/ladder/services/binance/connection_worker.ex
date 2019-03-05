defmodule Ladder.Services.Binanace.ConnectionWorker do
  use Ladder.Behaviours.BinanceWebsocket
  alias Ladder.Services.Binanace.ParserWorker

  def handle_decoded_msg(msg, stream_name) do
    ParserWorker.send(msg, stream_name)
  end
end
