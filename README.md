# Kwik
Kwik is a wiki engine written in Ruby, Markdown & MediaWiki compatible,
but without the bloated features.

It's intended to be used as a personal or small organization wiki,
where users are trusted and time is not meant to be spent on maintenance.

It can be configured to use different storages such as `database` or a `filesystem`.
By default it's configured to use the filesystem. To change it, create a .env file with this content:
```
REPO_IMPLEMENTATION=database
```

The available storages are:
- filesystem: useful as a personal-only wiki storage, it lets you use a VCS to keep a history of changes.
- database: any RDBMS supported by ActiveRecord. sqlite is already set up by default for personal environments but you can use mysql2 or postgres in case you want to run Kwik on Heroku or any other cloud platform. Modify `config/database.yml` to your needs.
- memory: an ephemeral store that it's deleted once the server restarts. Only useful for development or test.

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
