
module  Opsk
  class Analyze < Thor::Group
    include Thorable, Thor::Actions

    argument :file, :type => :string, :desc => 'the puppet log input file'
    class_option :threshold, :type=> :string, :desc => 'minimum run time filter'

    def report
	threshold = options['threshold'] || '0.01'
	rs = File.readlines(file).find_all{|line| line.include?('Evaluated')}
	top = rs.collect {|r| r.split(' ').values_at(3 , 7)}.find_all{|r| r[1].to_f > threshold.to_f}
	top.sort_by{|r| r[1].to_f}.reverse.each {|r|
        say("#{r[0]} #{r[1]}")
	}
    end
  end
end
