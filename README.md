# redis

This Zsh service-plugin will run `redis-server` pointing it to configuration file
`redis.conf`. This can be used with plugin [zdharma/zredis](https://github.com/zdharma/zredis)
to have the redis-backend running, to use *shared-variables* (between shells). Bind
the variables using lazy method (`-L {type}` option):

```zsh
ztie -d db/redis -f "127.0.0.1/3/MYLIST" -L list mylist
```

The command `ztie` is provided by [zdharma/zredis](https://github.com/zdharma/zredis) plugin.

## [Zplugin](https://github.com/zdharma/zplugin)

A service-plugin needs a plugin manager that supports loading single plugin instance
per all active Zsh sessions, in background. Zplugin supports this, just add:

```
zplugin ice service'redis'
zplugin light zservices/redis
```

to `~/.zshrc`.

## Explanation of Zsh-spawned services

First Zsh instance that will gain a lock will spawn the service. Other Zsh instances will
wait. When you close the initial Zsh session, another Zsh will gain lock and resume the
service. `zdharma/zredis` supports reconnecting, so all shared-variables will still work.
