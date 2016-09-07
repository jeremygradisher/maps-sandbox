#Maps Sandox
Sandbox using Leaflet and leaflet.pm
This was rebuilt from https://github.com/jeremygradisher/leaflet-sandbox which was basically markers as opposed to areas.

Adding leaflet.pm now! - http://codeofsumit.github.io/leaflet.pm/

---
#If cloning this realize a couple of things:

-it's using sqlite3 in development and PostgreSQL in production (gemfile)

-it uses AWS for file storage - just needs an S3 bucket and credentials
$ heroku config:set S3_ACCESS_KEY=xxxxxxxxxxxxxxxxxx
$ heroku config:set S3_SECRET_KEY=xxxxxxxxxxxxxxxxxx
$ heroku config:set S3_BUCKET=xxxxxxxxxxxxxxxxxx
