require "socket"

def log(message, src)
  puts "[#{Time.now}] [#{src}] #{message}"
end

def handle_client(client)
  log "Client is connected: #{client}", "server"
  while message = client.gets
    log "Message: #{message}", client
    client << "#{message}\n"
  end
  log "Closing client's connection: #{client}", "server"
  client.close
end

server = TCPServer.new("localhost", 3000)
puts "Listen 3000"
while client = server.accept?
  spawn handle_client(client)
end
