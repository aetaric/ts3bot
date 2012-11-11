#!/bin/ruby

require 'ts3query'
require 'firststart'
require 'yaml'

class TS3Bot
  
  def initialize
    # create config object
    @configfile = nil
    if File.exists? "config.yml"
      @configfile = File.open "config.yml", "r+"
      @firststart = false
    else
      @configfile = File.new "config.yml", "w+"
      @firststart = true
    end
  end
  
  def checkawaygroupignore(group)
    groups = group.split(",")
    ignore = @config[:away][:ignoregroups]
    groups.each do |g|
      ignore.each do |i|
        if g == i
          @ignore = true
        end
      end
    end
  end
  
  def checkidlegroupignore(group)
    groups = group.split(",")
    ignore = @config[:idle][:ignoregroups]
    @ignore = false
    groups.each do |g|
      ignore.each do |i|
        if g == i
          @ignore = true
        end
      end
    end
  end
  
  def mainloop
    puts "Starting main loop!"
    while @config[:whitelisted]
      
      if @config[:idle][:check] == true
        # idle times are in mill
        maxidle = @config[:idle][:timelimit] * 1000
        # are we warning the users?
        if @config[:idlewarnuser]
          warntime = @config[:idle][:warntime] * 1000
        end
        channelid = @config[:idle][:channelid]
        list = @ts3.clientlist do |opt|
          opt.away
          opt.times
          opt.uid
          opt.voice
          opt.groups
        end
        list.each do |o|
          if !(o[:clid].nil?)
            if checkidlegroupignore(o[:client_servergroups])
              if o[:client_idle_time] > maxidle
                @ts3.clientmove :clid => o[:clid], :cid => channelid
              end
            
              if @config[:idle][:warnuser]
                if o[:client_idle_time] > warntime
                  if !(o[:client_idle_time] < (warntime - 1000)) # don't spam warn. they should only be warned once. this assumes the bot executes this while loop in more than a second!
                    @ts3.sendtextmessage :targetmode => 3, :target => o[:clid], :msg => "You have been idle to long! If you don't participate soon you will be moved!"
                  end
                end
              end
            end
            
            if !(o[:notifytextmessage].exists?)
              # send o to command system
            end
          end
        end
      end
      
      if @config[:away][:check] == true
        channelid = @config[:away][:channelid]
        list = @ts3.clientlist do |opt|
          opt.away
          opt.times
          opt.uid
          opt.voice
          opt.groups
        end
        list.each do |o|
          if o[:client_away] == 1
            if checkidlegroupignore(o[:client_servergroups])
              @ts3.clientmove :clid => o[:clid], :cid => channelid
            end
          end
          if @config[:away][:muted] == true
            if o.client_output_muted == 1
              if checkidlegroupignore(o[:client_servergroups])
                @ts3.clientmove :clid => o[:clid], :cid => channelid
              end
            end
          end
        end
      end
      
    end
  end
  
  def run
    if @firststart == true
      temp = firststart
      @configfile.puts YAML.dump temp
      @configfile.close
      @configfile = temp.to_yaml
    end
    puts "Reading config file..."
    @config = YAML::load @configfile
    puts "Connecting to server #{@config[:ip]}:#{@config[:port]} as #{@config[:user]}..."
    @ts3 = TS3Query.connect :address => @config[:ip], :port => @config[:port].to_i, :username => @config[:user], :password => @config[:pass]
    # switch to the given serverid
    puts "Switching to server \# #{@config[:id]}..."
    @ts3.use :sid => @config[:id]
    # set our nickname
    puts "Updating our nickname to #{@config[:name]}..."
    @ts3.clientupdate :client_nickname => @config[:name]
    # register for text events so we can check for messages... not sure if this works or not...
    puts "Registering for events..."
    @ts3.servernotifyregister :event => 'textserver'
    @ts3.servernotifyregister :event => 'textchannel'
    @ts3.servernotifyregister :event => 'textprivate'
    # start the mainloop
    mainloop
  end
end