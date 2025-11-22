# oblyzer

**ob**sidian ana**lyzer**

some scripts for working with Obsidian vault

# obleaner

**ob**sidian c**leaner**

```
Usage:
  obleaner.pl [--dry-run] [--pix | -p] [--empty | -e] <obsidian vault path>

Options:
  --dry-run  Show what would be deleted, but do not delete anything
  --pix, -p  Delete all orphaned images
  --empty, -e Delete all empty .md files

Examples:
  obleaner.pl --dry-run -p /path/to/vault
  obleaner.pl -p -e /path/to/vault
```

# deps

- perl 5.10+
