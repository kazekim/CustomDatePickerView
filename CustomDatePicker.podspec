Pod::Spec.new do |s|
  s.name         = "CustomDatePicker"
  s.version      = "1.0.4"
  s.summary      = "Custom Date Picker for ios"
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/kazekim/CustomDatePickerView.git" ,
			:tag => s.version.to_s
		}
  s.description  = <<-DESC
                     Custom Date Picker
                    DESC
  s.homepage     = "https://github.com/kazekim/CustomDatePickerView"
  s.license      = 'MIT'
  s.author       = { "Jirawat Harnsiriwatanakit" => "jirawat.h@kazekim.com" }
  s.source_files = 'CustomDatePicker/*'
  s.requires_arc = true
end
