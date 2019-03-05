defprotocol IpcoinExchange do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end
