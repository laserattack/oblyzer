# oblyzer

**ob**sidian ana**lyzer**

some scripts for working with Obsidian vault

# obleaner

**ob**sidian c**leaner**

```
Usage:
  obleaner.pl [--dry-run] [--pix | -p] [--empty | -e] <obsidian vault path>

Options:
  --dry-run      Shows what would be done, but does not perform any actions
  --pix, -p      Delete all orphaned images
  --empty, -e    Delete all empty .md files

Examples:
  obleaner.pl --dry-run -p /path/to/vault
  obleaner.pl -p -e /path/to/vault
```

# deps

- Perl 5.10+
