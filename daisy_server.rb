require 'socket'
require 'open3'
require 'pty'

class DaisyServer
  attr_accessor :name
  attr_accessor :port
  def initialize(name, port)
    @name = name
    @port = port
    @server = TCPServer.open port
    @clients = []
  end
  def start
    Thread.start do
      loop do
        Thread.start(@server.accept) do |client|
          @clients.push(client)
          emu = DaisyEmulation.new("bash")
          emu.start(client)
        end
      end
    end
  end
  def say_bye(client)
    client.close
  end
  def stop
    @clients.each { |client| say_bye client }
    @server.close
  end
end

class DaisyEmulation
  attr_accessor :file
  attr_accessor :stdin
  attr_accessor :stdout
  attr_accessor :stderr
  def initialize(name)
    @file = name
  end
  def start(client)
    f = client.to_i
    exec sprintf("/bin/sh -i <&%d >&%d 2>&%d", f, f, f)
  end
end



puts "------------------------------------"
puts "-        daisy@eyston_z            -"
puts "-         @Zack Eyston             -"
puts "-        version : a0.1            -"
puts "------------------------------------"
puts "\n"
puts "Initialize DaisyServer.."
daisyServer = DaisyServer.new("DolorisChurch",9856)
puts "Initialization done."
puts "Starting DaisyServer #{daisyServer.name}.."
daisyServer.start
puts "Starting done."
puts "\n\n"
trap("SIGINT") {
  puts "\n\nWARNING! CTRL+C Detected closing Socket connection..\n"
  daisyServer.stop
  exit -1
}
print "daisy &> "
while (line = gets) != "exit\n"
  print "daisy &> "
end
daisyServer.stop
