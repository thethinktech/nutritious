class Newsletter < ActiveRecord::Base
  def check
    "#{email} #{status}"
  end
end
