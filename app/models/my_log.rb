class MyLog
  def self.info(message=nil)
    @my_log ||= Logger.new("#{Rails.root}/log/custom.log")
    @my_log.info(message) unless message.nil?
  end
end