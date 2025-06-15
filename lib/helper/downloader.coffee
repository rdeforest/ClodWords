# Download sources into memory
https = require 'https'
http  = require 'http'
{URL} = require 'url'

download = (url, redirects = 5) ->
  new Promise (resolve, reject) ->
    parsed = new URL url
    client = if parsed.protocol is 'https:' then https else http

    client.get url, (res) ->
      # Handle redirects
      if res.statusCode in [301, 302, 303, 307, 308]
        if redirects is 0
          reject new Error 'Too many redirects'
          return

        location = res.headers.location
        unless location
          reject new Error 'Redirect without location'
          return

        # Resolve relative redirects
        newUrl = new URL location, url
        resolve download newUrl.href, redirects - 1
        return

      # Check status
      if res.statusCode isnt 200
        reject new Error "HTTP #{res.statusCode}"
        return

      # Collect data
      chunks = []
      res.on 'data', (chunk) -> chunks.push chunk
      res.on 'end', -> resolve Buffer.concat chunks
      res.on 'error', reject
    .on 'error', reject

exports.downloadSource = (name, source) ->
  download source.url