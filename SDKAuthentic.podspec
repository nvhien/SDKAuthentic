
Pod::Spec.new do |s|

  s.name         = "SDKAuthentic"
  s.version      = "1.0"
  s.summary      = "SDKAuthentic"
  s.homepage     = "https://github.com/nvhien/SDKAuthentic"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "nvhien" => "nvhien.d13ptit@gmail.com" }
  s.platform     = :ios, "10.0"
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/nvhien/SDKAuthentic.git", :tag => "#{s.version}" }
  s.source_files  = "SDKAuthentic/**/*.{h,m,mm,cpp,c}"
  s.public_header_files = ['SDKAuthentic/*.h', 'SDKAuthentic/objects/*.h', 'SDKAuthentic/configuration/*.h']

  s.frameworks = "AVFoundation","Foundation","UIKit"
  s.libraries = "c++", "z"

  s.requires_arc = true
end
