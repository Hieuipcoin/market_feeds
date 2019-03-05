use Mix.Config
config :market_feeds, Ladder.Services.Binanace.Binance,
       endpoint: "wss://stream.binance.com:9443",
       streams: ["/ws/btcusdt@trade", "/ws/ltcbtc@trade"]