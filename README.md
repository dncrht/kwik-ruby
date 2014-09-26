# Kwik
Kwik is a wiki engine written in Ruby, MediaWiki compatible,
but without the bloated features.

It's intended to be used as a personal or small organization wiki,
where users are trusted and time is not meant to be spent on maintenance.

It uses the filesystem as storage, so there's no need to
set up a database backend.
The downside is that it won't run under _Heroku_ or similar cloud platforms.


## Launch the app at boot

### Mac OS X

Make sure the app is able to run:

```bash
bundle exec rails server -p 4040
open http://localhost:4040
```

Copy system/kwik.plist to ~/Library/LaunchAgents

```bash
cp system/kwik.plist ~/Library/LaunchAgents
```

Modify the file `~/Library/LaunchAgents/kwik.plist` to adjust some paths:
- /Users/your_user/.rbenv/shims/bundle: change your_user
- /Users/path/to/kwik: it should be the path to the kwik directory

All good! Launch the app now:

```bash
launchctl load ~/Library/LaunchAgents/kwik.plist
```

…or reboot your system!
