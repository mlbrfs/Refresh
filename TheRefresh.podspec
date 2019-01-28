Pod::Spec.new do |s|

  s.name         = "TheRefresh"
  s.version      = "1.0.0"
  s.summary      = "UIScrollView Refresh control for  swift4.2"

  s.description  = <<-DESC
                   UIScrollView Refresh control for swift4.2
		   下拉刷新和上拉加载更多的控制器
                   DESC

  s.homepage     = "https://github.com/121372288/Refresh"

  s.license      = "MIT"

  s.author       = { "121372288" => "121372288@qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/121372288/Refresh.git", :tag => s.version }

  s.swift_version = "4.2"

  s.source_files  = ["Refresh/**/*.swift", "Refresh/*.swift", "Refresh/Refresh.h"]
  s.public_header_files = ["Refresh/Refresh.h"]
  s.resource     = 'Refresh/Refresh.bundle'

  s.framework = "UIKit", "Foundation"

  s.requires_arc = true

end
