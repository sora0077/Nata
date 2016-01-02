
Pod::Spec.new do |s|

  s.name         = "Nata"
  s.version      = "1.0.1"
  s.summary      = "A sensible way to deal with XML & HTML for iOS"

  s.homepage     = "https://github.com/sora0077/Nata"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "sora0077" => "" }
  s.source       = { :git => "https://github.com/sora0077/Nata.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/**/*.{swift}"
  s.preserve_paths = "Frameworks/**"
  s.xcconfig  = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2", "SWIFT_INCLUDE_PATHS" => "$(PODS_ROOT)/Nata/Frameworks/Clibxml2" }

  s.platform = :ios
  s.ios.deployment_target = '8.0'
end
