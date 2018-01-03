class SmileDbBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "smile_#{Rails.env}".to_sym
end