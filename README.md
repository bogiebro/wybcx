Hosts 
=====
  - elena (deployment server): 128.36.90.138
  - github (collaboration): github.com/bogiebro/wybcx

Deploying
=========
    git push ssh://elena/home/node/wybcx
  - git's post-recieve hook clones the repo, then runs *naught deploy*
  - naught is initialized on startup by upstart
  - to manually start it, run *sudo start wybc*
  - naught starts node on port 3000
  - nginx does reverse proxy to route port 80 to 3000
  - naught is killed on shutdown by upstart
  - to manually stop it, run *sudo start nowybc*
  - all the logs are in /home/node/
