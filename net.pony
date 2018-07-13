use "net"

actor Main
  new create(env: Env) =>
    try
      let auth = env.root as AmbientAuth
      TCPListener(auth, recover Listener(env) end)
    else
      env.out.print("unable to use the network")
    end
