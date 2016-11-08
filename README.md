# Kwik
Kwik is a wiki engine written in Ruby, Markdown & MediaWiki compatible,
but without the bloated features.

It's intended to be used as a personal or small organization wiki,
where users are trusted and time is not meant to be spent on maintenance.

It uses the filesystem as storage, so there's no need to
set up a database backend.
The downside is that it won't run under _Heroku_ or similar cloud platforms.

## Installation

Make sure you have a working `ruby` > 1.9.3 installation, with `bundler`.

```bash
git clone https://github.com/dncrht/kwik.git
bundle
bundle exec rails server
open http://localhost:3000
```

### Page syntax

By default, Kwik assumes the pages are written using the Markdown syntax.
If you want to use Mediawiki, create a .env file with this content:
```
PARSER=mediawiki
```

## Launch the app at boot

### Mac OS X

Install [puma-dev](https://github.com/puma/puma-dev).

Symlink your kwik installation directory:
```bash
ln -s /Users/your_user/path/to/kwik .puma-dev
```

Now point your browser to [http://kwik.dev/](http://kwik.dev/)!
