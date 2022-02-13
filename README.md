# redis

This Zsh service-plugin will run `redis-server` pointing it to configuration
file `redis.conf`. This can be used with plugin
[zdharma-continuum/zredis](https://github.com/zdharma-continuum/zredis) to have
the redis-backend running, to use *shared-variables* (between shells). Bind the
variables using lazy method (`-L {type}` option):

```zsh
# Port 4815, database nr. 3, key "MYLIST"
ztie -d db/redis -f "127.0.0.1:4815/3/MYLIST" -L list mylist
```

The command `ztie` is provided by
[zdharma-continuum/zredis](https://github.com/zdharma-continuum/zredis) plugin.

## [zinit](https://github.com/zdharma-continuum/zinit)

A service-plugin needs a plugin manager that supports loading single plugin
instance per all active Zsh sessions, in background. zinit supports this, just
add:

```zsh
zinit ice service'redis'
zinit light zservices/redis
```

to `~/.zshrc`.

## Explanation of Zsh-spawned services

First Zsh instance that will gain a lock will spawn the service. Other Zsh
instances will wait. When you close the initial Zsh session, another Zsh will
gain lock and resume the service. `zdharma-continuum/zredis` supports
reconnecting, so all shared-variables will still work.
