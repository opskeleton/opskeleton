module Opsk 
  module Thorable
    def self.included klass
	def klass.source_root
	  # during dev time
	  if(File.dirname(__FILE__) == './bin')
	    File.dirname('.')
	  else 
	    "#{File.dirname(__FILE__)}/../../"
	  end
	end
    end
  end
end
