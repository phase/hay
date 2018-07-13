use "net"

class Listener is TCPListenNotify
  let _env: Env
  var _host: String = ""
  var _service: String = ""
  let _client_router: ClientRouter iso

  new create(env: Env) =>
    _env = env
    _client_router = ClientRouter(_env)

  fun ref listening(listen: TCPListener ref) =>
    try
      (_host, _service) = listen.local_address().name()?
      _env.out.print("[Listener] listening on " + _host + ":" + _service)
    else
      _env.out.print("[Listener] couldn't get local address")
      listen.close()
    end

  fun ref not_listening(listen: TCPListener ref) =>
    _env.out.print("[Listener] not listening")
    listen.close()

  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    _client_router
