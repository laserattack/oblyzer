# oblyzer

**ob**sidian ana**lyzer**

some scripts for working with Obsidian vault

# obleaner

**ob**sidian c**leaner**

```
Usage:
  obleaner.pl [--dry-run] [--pix] [--empty] <obsidian vault path>

Options:
  --dry-run  Show what would be deleted, but do not delete anything.
  --pix      Delete all orphaned images.
  --empty    Delete all empty .md files.

Examples:
  obleaner.pl --dry-run --pix /path/to/vault
  obleaner.pl --pix --empty /path/to/vault
```

# deps

- perl 5.10+
