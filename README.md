# `REDIS` ZINIT SERVICE

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
  - [Zinit](#zinit)
  - [Explanation of Zsh-spawned services](#explanation-of-zsh-spawned-services)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Introduction

This Zsh service-plugin will run `redis-server` pointing it to configuration file
`redis.conf`. This can be used with plugin [z-shell/zredis](https://github.com/z-shell/zredis)
to have the redis-backend running, to use *shared-variables* (between shells). Bind
the variables using lazy method (`-L {type}` option):

```zsh
# Port 4815, database nr. 3, key "MYLIST"
ztie -d db/redis -f "127.0.0.1:4815/3/MYLIST" -L list mylist
```

The command `ztie` is provided by [z-shell/zredis](https://github.com/z-shell/zredis) plugin.

## [Zinit](https://github.com/z-shell/zinit)

A service-plugin needs a plugin manager that supports loading single plugin instance
per all active Zsh sessions, in background. Zinit supports this, just add:

```
zinit ice service'redis'
zinit light z-shell/redis
```

to `~/.zshrc`.

## Explanation of Zsh-spawned services

First Zsh instance that will gain a lock will spawn the service. Other Zsh instances will
wait. When you close the initial Zsh session, another Zsh will gain lock and resume the
service. `z-shell/zredis` supports reconnecting, so all shared-variables will still work.
