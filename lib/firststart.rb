require 'yaml'
require 'string'
  
def firststart
    temp = {}
    
    puts "Thanks for using the Teamspeak3 Ruby Bot!"
    puts "This will ask you a series of questions to setup the bot for you."
    puts "Defaults will be listed in brackets. i.e. 'username? [serveradmin]'"
    puts ""
    puts "First a few questions about your connection..."
    puts ""
      
    puts "{connection} What is the ip of the server you wish to connect to? [127.0.0.1]"
    temp[:ip] = gets.strip
    if temp[:ip].empty?
      temp[:ip] = "127.0.0.1"
    end
      
    puts "{connection} What is the port you want to conenct to? [10011]"
    temp[:port] = gets.strip.to_i
    if temp[:port] == 0
      temp[:port] = 10011
    end
      
    puts "{connection} What is the username you wish to connect with? [serveradmin]"
    temp[:user] = gets.strip
    if temp[:user].empty?
      temp[:user] = "serveradmin"
    end
      
    puts "{connection} What is the password for #{temp[:user]}?"
    temp[:pass] = gets.strip
      
    puts "{connection} Is this computer's IP address whitelisted on the server? [yes]"
    temp[:whitelisted] = gets.strip.to_bool
    if temp[:whitelisted] == nil
      temp[:whitelisted] = true
    end
    
    puts "{connection} What name do you want the bot to have? [TS3Server]"
    temp[:name] = gets.strip
    if temp[:name].empty?
      temp[:name] = "TS3Bot"
    end
    
    puts "{connection} Which server id do you want to conenct to? [1]"
    temp[:id] = gets.strip.to_i
    if temp[:id] == 0
      temp[:id] = 1
    end
      
    puts ""
    puts "Now we will go over a few basic scenarios to get an idea of what rules you want to enforce..."
    puts ""
    
    temp[:idle] = {}
    puts "{idlecheck} Would you like for a user who has been idle (not spoken or typed to anyone) within a certain timelimit to be moved to another channel? *This affects all channels not just the channel the bot is in.* [yes]"
    temp[:idle][:check] = gets.strip.to_bool
    if temp[:idle][:check] == nil
      temp[:idle][:check] = true
    end
    # options for idlecheck
    if temp[:idle][:check] == true
      puts "  {idlecheck} At what length of time (in minutes) would you like the bot to move a user? [30]"
      time = gets.strip.to_i
      if time == 0
        time = 30
      end
      temp[:idle][:timelimit] = time.to_i * 60 # the config file will store it in seconds.
      time = nil
        
      puts "  {idlecheck} Would you like to warn users that they are about to be moved? [yes]"
      temp[:idle][:warnuser] = gets.strip.to_bool
      if temp[:idle][:warnuser] == nil
        temp[:idle][:warnuser] = true
      end
      
      if temp[:idle][:warnuser] == true
        puts "  {idlecheck} At what length of time (in minutes) should a user be warned? [25]"
        time = gets.strip.to_i
        if time == 0
          time = 25
        end
        temp[:idle][:warntime] = time.to_i * 60 # again store as seconds
      end
        
      puts "  {idlecheck} What channel id should Idle users be moved to? You should set this to the ID of your AFK channel if you have one."
      temp[:idle][:channelid] = gets.strip.to_i
      
      puts "  {idlecheck} Are there server groups that you want the bot to ignore? Please use the format: 6,7,8"
      temp[:idle][:ignoregroups] = gets.strip.split(",")
    end
    
    temp[:away] = {}
    puts "{awaycheck] Would you like a user who has set their status to away to be moved to another channel? [yes]"
    temp[:away][:check] = gets.strip.to_bool
    if temp[:away][:check] == nil
      temp[:away][:check] = true
    end
      
    # options for awaycheck
    if temp[:away][:check] == true
      puts "  {awaycheck} What is the channel id you want the user moved to? Again set this to an AFK channel if you have one."
      temp[:away][:channelid] = gets.strip.to_i
      
      puts "  {awaycheck} Do you want muted players moved as well? [no]"
      temp[:away][:muted] = gets.strip.to_bool
      if temp[:away][:muted] == nil
        temp[:away][:muted] = false
      end
      
      puts "  {awaycheck} Are there server groups that you want the bot to ignore? Please use the format: 6,7,8"
      temp[:away][:ignoregroups] = gets.strip.split(",")
    end
    
    puts "{Admins} What are the Unique IDs of the users you want to set as admins? Please use the format: lyuF1mxRoWT40cY6pReCEhYVIw4=,A2mBZX8Eoa9nCdNB54uXupmHL4s=,1zVK0xwTaTI0nu2CX2qiF0DP04w="
    temp[:admins] = gets.strip.split(",")
    
    #######################
    ## DEBUG YAML OUTPUT ##
    # puts YAML.dump temp #
    ## DEBUG YAML OUTPUT ##
    #######################
    
    return temp
end