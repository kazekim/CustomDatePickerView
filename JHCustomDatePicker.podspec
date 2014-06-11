Pod::Spec.new do |s|
  s.name         = "JHCustomDatePicker"
  s.version      = "1.0.9"
  s.summary      = "Custom Date Picker for ios"
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/kazekim/CustomDatePickerView.git" ,
			:tag => s.version.to_s
		}
  s.description  = <<-DESC
                     Custom Date Picker for iOS by Jirawat Harnsiriwatanakit
                    DESC
  s.homepage     = "https://github.com/kazekim/CustomDatePickerView"
  s.license      = 'MIT'
  s.author       = { "Jirawat Harnsiriwatanakit" => "jirawat.h@kazekim.com" }
  s.source_files = 'CustomDatePicker/*'
  s.requires_arc = true
end
