#Maps Sandox
Sandbox using Leaflet and leaflet.draw
This was rebuilt from https://github.com/jeremygradisher/leaflet-sandbox which was basically markers as opposed to areas.

*I was going to use this:
Adding leaflet.pm now! - http://codeofsumit.github.io/leaflet.pm/

**But I changed my mind and went with:
leaflet.draw - https://github.com/Leaflet/Leaflet.draw
example: http://leaflet.github.io/Leaflet.draw/
(More options, more documentation and more people using it)


---
#If cloning this realize a couple of things:

-it's using sqlite3 in development and PostgreSQL in production (gemfile)

-it uses AWS for file storage - just needs an S3 bucket and credentials
$ heroku config:set S3_ACCESS_KEY=xxxxxxxxxxxxxxxxxx
$ heroku config:set S3_SECRET_KEY=xxxxxxxxxxxxxxxxxx
$ heroku config:set S3_BUCKET=xxxxxxxxxxxxxxxxxx
