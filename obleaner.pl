#!/usr/bin/env perl

use feature "say";
use strict;
use warnings;
use File::Find;

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
                if (unlink $path) {
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
            if (unlink $path) {
                say "Deleted '$path'";
            } else {
                warn "Failed to delete '$path': $!";
            }
        }, $start_dir);
}

sub cleanup {
    my ($start_dir, $mode) = @_;
    $mode //= "";

    if ($mode eq "pix") {
        cleanupPix $start_dir;
    }
    elsif ($mode eq "empty") {
        cleanupEmpty $start_dir;
    }
    else {
        cleanupPix $start_dir;
        cleanupEmpty $start_dir;
    }
}

if (@ARGV < 1) {
    say '1. obleaner.pl <obsidian vault path> pix      # delete all orphans pix';
    say '2. obleaner.pl <obsidian vault path> empty    # delete all 0-bytes md files';
    say '3. obleaner.pl <obsidian vault path>          # 1. + 2.';
} else {
    cleanup @ARGV;
}
