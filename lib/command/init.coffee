# Initialize ClodWords configuration
{writeFileSync, existsSync} = require 'fs'
yaml                        = require 'js-yaml'
{detectProfiles}            = require '../helper/firefox'

defaultConfig = ->
  sources:
    'scowl-github':
      url:       'https://github.com/en-wl/wordlist/archive/refs/heads/master.zip'
      processor: 'scowl'
      enabled:   true
      priority:  1
    'webster1913-gutenberg':
      url:       'https://www.gutenberg.org/files/29765/29765-0.txt'
      processor: 'webster'
      enabled:   true
      priority:  2
    'moby-gutenberg':
      url:       'https://www.gutenberg.org/files/3201/files.zip'
      processor: 'moby'
      enabled:   true
      priority:  3

  processing:
    min_length:       2
    max_length:       50
    allowed_chars:    "a-zA-Z'-"
    exclude_patterns: ["^[A-Z]{2,}$", ".*[0-9].*"]

  firefox:
    profiles:         []
    create_symlinks:  true
    backup_original:  true
    dict_filename:    'persdict.dat'

  output:
    dict_path: 'dist/persdict.dat'
    format:    'firefox'

exports.run = (args) ->
  if existsSync 'config.yaml'
    console.log '⚠ config.yaml exists'
    console.log 'Use "cake configure" to modify'
    return

  config = defaultConfig()

  # Try to detect Firefox profiles
  detected = detectProfiles()
  if detected.length > 0
    console.log "✓ Found Firefox profiles:"
    for p in detected
      console.log "  • #{p}"
    config.firefox.profiles = detected
  else
    console.log '⚠ No Firefox profiles found'
    console.log 'Run "cake configure browser" later'

  # Write config
  writeFileSync 'config.yaml', yaml.dump config
  console.log '✓ Created config.yaml'

  # Show next steps
  console.log '\nNext steps:'
  console.log '  cake configure      # Review settings'
  console.log '  cake source list    # Check sources'
  console.log '  cake publish        # Build dictionary'
