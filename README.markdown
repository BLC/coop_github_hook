## Coop Github Hook
This [sinatra](http://sinatarb.com) script listens acts as a [github post-receive hooks](http://github.com/guides/post-receive-hooks) and after each commit fires a status message to a [Coop](http://coopapp.com) of your choosing, adding commit history into your message/time entry history.

## 3 Step Usage Guide

### Step 1
This app calls out to sinatra to start up, so any options you can pass to a sinatra app you can pass to this. Example usage:
    script/coop-post -p 4678

You will be asked for a coop username, password, and the id of the group you'd like to put the status message under. This is the user that the github messages will be posted under and must have access to the group you want to post messages too. To simplify life you can create a config/coop-creds.yml file with this information stored in it.

Example config/coop-creds.yml (configuration file):
    ---
      username: coopguy@something.com
      password: LotsOfInfo
      group_id: 5234

You can find your group\_id by looking at your group's url after logging into coop. The url will be similar to http://coopapp.com/groups/5234, where 5234 is the group_id.

### Step 2
Go to github and setup your server as a [post-receive hook](http://github.com/guides/post-receive-hooks).

### Step 3
Do a commit and you should see a message like:
    Hero Siresh@http://github.com/main_user/project/commit/123ebb12eaf6ba3189346207daa5f9e48bf80119 : First line of commit message

That's somewhat long-winded but until coop exposes markup compatible status messages it's the best I can do.

## Deploy
I haven't bothered to capistrano'ize this script, but to simplify deploying it there's rake deploy which will scp your files over to a server of your choosing. This requires a config/deploy.yml configuration file to be filled out.

Example config/deploy.yml:
    ---
      server: externally_accessible_server
      folder: /home/github/github-post-commits

## Monit
If you want to monitor your hook server with monit you can use the provided script/monit-wrapper.sh script. This script takes either start or stop, and will run script/coop-post after generating a pid file so that monit can try and stop it if necessary, and monitor if it's running.

This script requires a port to be specified in config/port.

Example config/port file:
    12345

Example monit config

    check process coop-post with pidfile /home/github/github-post-commits/tmp/coop-post.pid
       start program = "su - github_hook_user -c '/home/github/github-post-commits start'"
       stop program = "su - github_hook_user -c '/home/github/github-post-commits stop'"

Then run `sudo monit coop-post start` to start the server and nd check on it with `sudo monit status`

## References
* [github post-receive hooks](http://github.com/guides/post-receive-hooks) 
* [coop api](http://coopapp.com/api)
* [sinatra](http://sinatrarb.com)