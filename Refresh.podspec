Pod::Spec.new do |s|

  s.name         = "Refresh"
  s.version      = "0.0.1"
  s.summary      = "A short description of Refresh."

  s.description  = <<-DESC
                   DESC

  s.homepage     = "http://EXAMPLE/Refresh"

  s.license      = "MIT (example)"

  s.author             = { "" => "" }

  s.platform     = :ios, "5.0"

  s.source       = { :git => "http://EXAMPLE/Refresh.git", :tag => "#{s.version}" }


  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"


  s.resource  = "icon.png"
  s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
