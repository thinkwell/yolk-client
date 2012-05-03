require 'hashie/mash'
require 'rash'
class Yolk::Model < Hashie::Rash
#  def regular_writer(key,value) #:nodoc:
#    super(*convert_pair(key, value))
#  end
#  protected
#  def convert_pair key, value
#    if value && value.is_a?(String) && key =~ /_(date|at)$/
#      [key, Time.parse(value)]
#    else
#      [key, value]
#    end
#  end
end
