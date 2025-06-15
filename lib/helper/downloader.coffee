# Download sources into memory
fetch = require 'node-fetch'

exports.downloadSource = (name, source) ->
  response = await fetch source.url

  unless response.ok
    throw new Error "HTTP #{response.status}"

  # Get as buffer for binary files
  buffer = await response.arrayBuffer()
  Buffer.from buffer