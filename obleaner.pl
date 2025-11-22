#!/usr/bin/env perl
use feature "say";
use strict;
use warnings;
use File::Find;
use Getopt::Long;

my $dry_run = 0;
my $clean_pix = 0;
my $clean_empty = 0;
my $vault_path;

sub fileContent {
    my ($fileName) = @_;
    return do {
               open my $fh, '<', $fileName or die $!;
               local $/;
               <$fh>;
           };
}

sub cleanupPix {
    my ($start_dir) = @_;
    my %pix;
    find(sub {
            return unless -f $_ and $_ =~ /^.+\.md$/i;
            my @matches = fileContent($File::Find::name) =~ /!\[\[(.*?)\]\]/g;
            $pix{$_}++ for @matches;
        }, $start_dir);
    find(sub {
            return unless -f $_ and $_ =~ /^.+\.(png|jpe?g|webp|gif|bmp|ppm)$/i;
            unless (exists $pix{$_}) {
                my $path = $File::Find::name;
                if ($dry_run || unlink $path) {
                    say "Deleted '$path'";
                } else {
                    warn "Failed to delete '$path': $!";
                }
            }
        }, $start_dir);
}

sub cleanupEmpty {
    my ($start_dir) = @_;
    find(sub {
            return unless -f $_ and $_ =~ /^.+\.md$/i;
            my $path = $File::Find::name;
            return unless -z $path;
            if ($dry_run || unlink $path) {
                say "Deleted '$path'";
            } else {
                warn "Failed to delete '$path': $!";
            }
        }, $start_dir);
}

sub usage {
    say 'Usage:';
    say '  obleaner.pl [--dry-run] [--pix | -p] [--empty | -e] <obsidian vault path>';
    say '';
    say 'Options:';
    say '  --dry-run      Shows what would be done, but does not perform any actions';
    say '  --pix, -p      Delete all orphaned images';
    say '  --empty, -e    Delete all empty .md files';
    say '';
    say 'Examples:';
    say '  obleaner.pl --dry-run -p /path/to/vault';
    say '  obleaner.pl -p -e /path/to/vault';
}

sub main {
    if ($clean_pix) {
        cleanupPix($vault_path);
    }
    if ($clean_empty) {
        cleanupEmpty($vault_path);
    }
    if (!$clean_pix && !$clean_empty) {
        usage();
    }
}

GetOptions(
    "dry-run", \$dry_run,
    "pix|p", \$clean_pix,
    "empty|e", \$clean_empty,
) or do {
    usage();
    exit;
};

if (@ARGV != 1) {
    usage();
    exit;
} else {
    $vault_path = $ARGV[0];
}

main();
