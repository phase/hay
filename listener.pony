use "net"
use "files"

class Listener is TCPListenNotify
  let _env: Env
  let _limit: USize
  var _host: String = ""
  var _service: String = ""
  var _count: USize = 0

  new create(env: Env, limit: USize) =>
    _env = env
    _limit = limit

  fun ref listening(listen: TCPListener ref) =>
    try
      (_host, _service) = listen.local_address().name()?
      _env.out.print("[TCPListener] listening on " + _host + ":" + _service)
      _spawn(listen)
    else
      _env.out.print("[TCPListener] couldn't get local address")
      listen.close()
    end

  fun ref not_listening(listen: TCPListener ref) =>
    _env.out.print("[TCPListener] not listening")
    listen.close()

  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    _env.out.print("[TCPListener] starting server")
    let server = ServerSide(_env)

    _spawn(listen)
    server

  fun ref _spawn(listen: TCPListener ref) =>
    if (_limit > 0) and (_count >= _limit) then
      listen.dispose()
      return
    end

    _count = _count + 1
    _env.out.print("[TCPListener] spawn client #" + _count.string() + "/" + _limit.string())

    try
      TCPConnection(_env.root as AmbientAuth, ClientSide(_env), _host, _service)
    else
      _env.out.print("[TCPListener] couldn't create client side")
      listen.close()
    end
