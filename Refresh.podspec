Pod::Spec.new do |s|

  s.name         = "Refresh"
  s.version      = "1.0.0"
  s.summary      = "which implement by Swift."

  s.description  = <<-DESC
                   UIScrollView Refresh control for swift3.0 
                   DESC

  s.homepage     = "https://github.com/121372288/Refresh"

  s.license      = "MIT"

  s.author       = { "121372288" => "121372288@qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/121372288/Refresh.git", :tag => "1.0.0" }


  s.source_files  = "Refresh/*"


  s.framework = "UIKit", "Foundation"

  s.requires_arc = true

end
