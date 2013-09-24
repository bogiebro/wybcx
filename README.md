Hosts 
=====
  - elena (deployment server): 128.36.90.138
  - github (collaboration): github.com/bogiebro/wybcx

Deploying
=========
    git push ssh://elena/home/node/wybcx
  - git's post-recieve hook runs *naught deploy*
  - naught is initialized called on startup by upstart
  - all the logs are in /home/node/
