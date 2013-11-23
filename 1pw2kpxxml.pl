#!/usr/bin/perl -w
# 1pw2kpxxml.pl - convert 1Password Exchange file to KeePassX XML
# created by scruss on 02013/04/21

use strict;
use JSON::XS;
use HTML::Entities;
use Time::Piece;

# print xml header
print <<HEADER;
<!DOCTYPE KEEPASSX_DATABASE>
<database>
 <group>
  <title>General</title>
  <icon>2</icon>
HEADER

##############################################################
# Field Map
#
# 1Password			KeePassX
# ============================  ==============================
# title        			title
# username			username
# password			password
# location			url
# notesPlain			comment
#    -				icon
# createdAt			creation
#    -				lastaccess	(use updatedAt)
# updatedAt			lastmod
#    -				expire		('Never')

# 1PW exchange files are made of single lines of JSON (O_o)
# interleaved with separators that start '**'
while (<>) {
    next if (/^\*\*/);    # skip separator
    my $rec = decode_json($_);

    # throw out records we don't want:
    #  - 'trashed' entries
    #  -  system.sync.Point entries
    next if ( exists( $rec->{'trashed'} ) );
    next if ( $rec->{'typeName'} eq 'system.sync.Point' );

    print '  <entry>', "\n";    # begin entry

    ################
    # title field
    print '   <title>', xq( $rec->{'title'} ), '</title>', "\n";

    ################
    # username field - can be in one of two places
    my $username = '';

    # 1. check secureContents as array
    foreach ( @{ $rec->{'secureContents'}->{'fields'} } ) {
        if (
            (
                exists( $_->{'designation'} )
                && ( $_->{'designation'} eq 'username' )
            )
          )
        {
            $username = $_->{'value'};
        }
    }

    # 2.  check secureContents as scalar
    if ( $username eq '' ) {
        $username = $rec->{'secureContents'}->{'username'}
          if ( exists( $rec->{'secureContents'}->{'username'} ) );
    }

    print '   <username>', xq($username), '</username>', "\n";

    ################
    # password field - as username
    my $password = '';

    # 1. check secureContents as array
    foreach ( @{ $rec->{'secureContents'}->{'fields'} } ) {
        if (
            (
                exists( $_->{'designation'} )
                && ( $_->{'designation'} eq 'password' )
            )
          )
        {
            $password = $_->{'value'};
        }
    }

    # 2.  check secureContents as scalar
    if ( $password eq '' ) {
        $password = $rec->{'secureContents'}->{'password'}
          if ( exists( $rec->{'secureContents'}->{'password'} ) );
    }

    print '   <password>', xq($password), '</password>', "\n";

    ################
    # url field
    print '   <url>', xq( $rec->{'location'} ), '</url>', "\n";

    ################
    # comment field
    my $comment = '';
    $comment = $rec->{'secureContents'}->{'notesPlain'}
      if ( exists( $rec->{'secureContents'}->{'notesPlain'} ) );
    $comment = xq($comment);    # pre-quote
    $comment =~ s,\\n,<br/>,g;  # replace escaped NL with HTML
    $comment =~ s,\n,<br/>,mg;  # replace NL with HTML
    print '   <comment>', $comment, '</comment>', "\n";

    ################
    # icon field (placeholder)
    print '   <icon>2</icon>', "\n";

    ################
    # creation field
    my $creation = localtime( $rec->{'createdAt'} );
    print '   <creation>', $creation->datetime, '</creation>', "\n";

    ################
    # lastaccess field
    my $lastaccess = localtime( $rec->{'updatedAt'} );
    print '   <lastaccess>', $lastaccess->datetime, '</lastaccess>', "\n";

    ################
    # lastmod field (= lastaccess)
    print '   <lastmod>', $lastaccess->datetime, '</lastmod>', "\n";

    ################
    # expire field (placeholder)
    print '   <expire>Never</expire>', "\n";

    print '  </entry>', "\n";    # end entry
}

# print xml footer
print <<FOOTER;
 </group>
</database>
FOOTER

exit;

sub xq {                         # encode string for XML
    $_ = shift;
    return encode_entities( $_, q/<>&"'/ );
}

