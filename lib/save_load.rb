# lib/save_load.rb

module SaveLoad
 def self.duplicate(state)
   Marshal.load(Marshal.dump(a))
 end

 def self.save end

 def self.load end
end
