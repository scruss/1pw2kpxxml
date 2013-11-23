1pw2kpxxml.pl
=============

A program to convert 1Password Interchange File data to KeePassX XML data

Stewart C. Russell - scruss.com - 2013-04-24

Usage
-----

	./1pw2kpxxml.pl data.1pif > data.xml

You can then import data.xml into KeePassX.

Please be careful to delete the 1PIF file and the data.xml once
you've finished the export/import. These files contain all of
your passwords in plain text; if they fell into the wrong hands,
it would be a disaster for your online identity. Be careful that
none of these files accidentally slip onto backups, too. Also
note that, while I think I'm quite a trustworthy bloke, to you,
I'm *Some Random Guy On The Internet*. Check this code
accordingly; I don't warrant it for anything save for looking
like line noise.

Notable limitations
-------------------
* All attached files in the database are lost.
* All entries are stored under the same folder, with the same
  icon. (sorry, I didn't even know that feature existed in 1Password.)
* It has not been widely tested, and as I’m satisfied with its
  conversion, it will not be developed further.

More details at: [Mac to Linux: 1Password to KeePassX](http://scruss.com/blog/2013/04/24/mac-to-linux-1password-to-keepassx "Mac to Linux: 1Password to KeePassX")

Licence
-------

WTFPL. (Srsly; see COPYING.)
