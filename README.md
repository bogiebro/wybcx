Hosts 
=====
  - elena (deployment server): 128.36.90.138
  - github (collaboration): github.com/bogiebro/wybcx

Deploying
=========
    git push ssh://elena/home/node/wybcx
  - git's post-recieve hook clones the repo, then runs *naught deploy*
  - naught is initialized on startup by upstart
  - naught starts node on port 3000
  - nginx does reverse proxy to route port 80 to 3000
  - all the logs are in /home/node/
