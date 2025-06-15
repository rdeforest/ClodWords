# Firefox profile detection
{homedir}              = require 'os'
{existsSync, readdirSync} = require 'fs'
{join}                 = require 'path'

firefoxPaths = ->
  home = homedir()

  switch process.platform
    when 'darwin'
      [
        "#{home}/Library/Application Support/Firefox/Profiles"
      ]
    when 'linux'
      [
        "#{home}/.mozilla/firefox"
        "#{home}/.var/app/org.mozilla.firefox/.mozilla/firefox"
        "#{home}/snap/firefox/common/.mozilla/firefox"
      ]
    when 'win32'
      [
        "#{home}/AppData/Roaming/Mozilla/Firefox/Profiles"
      ]
    else
      []

exports.detectProfiles = ->
  profiles = []

  for basePath in firefoxPaths()
    continue unless existsSync basePath

    try
      entries = readdirSync basePath, withFileTypes: true

      for entry in entries
        continue unless entry.isDirectory()
        continue unless entry.name.includes '.'

        profilePath = join basePath, entry.name
        # Check if it looks like a profile
        if existsSync join profilePath, 'prefs.js'
          profiles.push profilePath
    catch
      # Skip inaccessible directories

  profiles