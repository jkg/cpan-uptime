CPAN Search Uptime Monitoring
=============================

The Data
--------

The tool stores data in results.sqlite. I will update the instance of this in the repo periodically.

### Schema

CREATE TABLE results ( result integer, seconds integer, timestamp integer, site text );

### Notes

* Result is really a boolean; 1 indicates success, 0 failure.
* Seconds is the time in _milliseconds_ that the request took to complete (roughly), as an integer.
* Timestamp is the UNIX time at which the result was _stored_.
* Site will either be "meta" or "sco", for http://metacpan.org/ or http://search.cpan.org/ respectively.

Methodology
-----------

This is not a complex test. We use LWP::UserAgent to fetch the documentation for Moose from each site (i.e. /pod/Moose or /perldoc?Moose) respectively. If the response object indicates success, we believe it -- otherwise we assume failure. No attempt is made to understand HTTP status codes.

Duration is measured by calling Time::HiRes' time() before, and after, calling $ua->get($url).

Suggested improvements are welcome; especially if they come in early, or don't invalidate the existing data :-)

Purpose
-------

It's a widely held belief that search.cpan.org is "always" down. It's often said in response that MetaCPAN is "often slow". It feels as if we can establish the truth of these claims very simply - so, I'm gathering the data.

See http://dillig.af/100/ for more context.