use "net"

class ClientRouter is TCPConnectionNotify
  let _env: Env

  new iso create(env: Env) =>
    _env = env

  fun ref accepted(conn: TCPConnection ref) =>
    try
      (let host, let service) = conn.remote_address().name()?
      _env.out.print("[ClientRouter] accepted from " + host + ":" + service)
    end

  fun ref received(conn: TCPConnection ref, data: Array[U8] iso,
    times: USize): Bool
  =>
    _env.out.print("[ClientRouter] Recieved data:")
    for byte in (consume data).values() do
      _env.out.write(byte.string())
      _env.out.write(" ")
    end
    _env.out.print("")
    conn.dispose()
    true

  fun ref closed(conn: TCPConnection ref) =>
    _env.out.print("[ClientRouter] server closed")

  fun ref connect_failed(conn: TCPConnection ref) =>
    _env.out.print("[ClientRouter] connect failed")
