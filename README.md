<h2 align="center">
  <a href="https://github.com/z-shell/zi">
    <img src="https://github.com/z-shell/zi/raw/main/docs/images/logo.svg" alt="Logo" width="80" height="80">
  </a>
❮ ZI ❯ Service - Redis
</h2>

This Zsh service-plugin will run `redis-server` pointing it to configuration file
`redis.conf`. This can be used with plugin [z-shell/zredis](https://github.com/z-shell/zredis)
to have the redis-backend running, to use *shared-variables* (between shells). Bind
the variables using lazy method (`-L {type}` option):

```zsh
# Port 4815, database nr. 3, key "MYLIST"
ztie -d db/redis -f "127.0.0.1:4815/3/MYLIST" -L list mylist
```

The command `ztie` is provided by [z-shell/zredis](https://github.com/z-shell/zredis) plugin.

## [ZI](https://github.com/z-shell/zi)

A service-plugin needs a plugin manager that supports loading single plugin instance
per all active Zsh sessions, in background. ZI supports this, just add:

```
zi ice service'redis'
zi light z-shell/redis
```

to `~/.zshrc`.

## Explanation of Zsh-spawned services

First Zsh instance that will gain a lock will spawn the service. Other Zsh instances will
wait. When you close the initial Zsh session, another Zsh will gain lock and resume the
service. `z-shell/zredis` supports reconnecting, so all shared-variables will still work.
