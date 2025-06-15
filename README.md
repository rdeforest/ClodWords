# ClodWords

Enhanced Firefox dictionary builder - eliminate spell-check false positives with a comprehensive ~600k word dictionary.

## Quick Start

```bash
# Clone and setup
git clone https://github.com/rdeforest/ClodWords.git
cd ClodWords
npm install

# Initialize
node_modules/coffeescript/bin/cake init

# Build and deploy dictionary
cake publish
```

## Usage

ClodWords uses a Cake-based interface for all operations:

```bash
cake init                    # First time setup
cake configure               # View configuration
cake configure browser       # Auto-detect Firefox profiles
cake source list             # Show word sources
cake source disable webster  # Skip a source
cake publish                 # Complete pipeline (fetch→build→deploy)
cake status                  # Show current state
```

## Word Sources

- **SCOWL** (GitHub): ~500k modern English words
- **Webster's 1913** (Gutenberg): ~120k classical terms
- **Moby Project** (Gutenberg): ~390k comprehensive wordlist

## Configuration

Edit `config.yaml` to customize:

- Enable/disable sources
- Adjust filtering rules (length, characters, patterns)
- Configure Firefox profile paths
- Choose symlink vs copy deployment

## Requirements

- Node.js v24 or higher
- Firefox browser
- Unix-like system (Linux/macOS) or WSL on Windows

## Architecture

Pure CoffeeScript implementation following Unix philosophy:
- Single-purpose tools composed via Cakefile
- In-memory processing (no intermediate files)
- Clean separation of commands and helpers
- <100 line modules, <20 line functions

## License

MIT