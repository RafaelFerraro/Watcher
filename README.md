# Ruby application

#### Workflow:
###### Listens for a specific directory and emits a log message when an update occurs into this one, like as file modification, addition or removal.

<br/>

#### How it works ?
###### Starts a ruby process/application
ruby bin/watcher start

While this has been running, a Listener(https://rubygems.org/gems/listen) will be, of course, listen to a specific directory

What about that directory? This it's included into a YAML file - config/config.yml - as value of folder key.


