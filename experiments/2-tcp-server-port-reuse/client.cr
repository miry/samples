require "socket"

def log(message, src)
  print "[#{Time.now}] [#{src}] #{message}\n"
end

def pinger(server_ip, client_id)
  client = TCPSocket.new(server_ip, 3000)
  log client.gets, client_id
  client.close
end

server_ip = "127.0.0.1"
server_ip = ARGV[0] if ARGV.size > 0
10.times do |i|
  spawn pinger(server_ip, i)
end

sleep 10
