Hosts 
=====
  - github (collaboration): github.com/bogiebro/wybcx
  - heroku (deployment): git@heroku.com:wybcx.git
  - postgresql and redis are hosted on heroku
  - we should put static stuff on amazon s3

Architecture
============
  - everything is written in Livescript (like Javascript)
  - static assets (in app/) are all compiled with brunch on install
    - build steps are managed in config.ls
    - dependencies are managed in bower.json
    - we have angular modules for dj, listener, admin, and utilities
  - app.ls contains all http routing
  - model.ls contains all communication with postgres
  - sockets.ls contains all communication with redis and socketio
  - migrations are run on install