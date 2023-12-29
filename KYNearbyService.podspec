Pod::Spec.new do |spec|
  spec.name         = "KYNearbyService"
  spec.version      = "1.1.0"
  spec.summary      = "A service for nearby discovery and communication."
  spec.license      = "MIT"
  spec.source       = { :git => "https://github.com/Kjuly/KYNearbyService.git", :tag => spec.version.to_s }
  spec.homepage     = "https://github.com/Kjuly/KYNearbyService"
  spec.screenshots  = "https://raw.githubusercontent.com/Kjuly/preview/main/KYNearbyService/01.png", "https://raw.githubusercontent.com/Kjuly/preview/main/KYNearbyService/Mac_01.png"

  spec.author             = { "Kjuly" => "dev@kjuly.com" }
  spec.social_media_url   = "https://twitter.com/kJulYu"

  spec.ios.deployment_target = "15.5"
  spec.osx.deployment_target = "12.0"

  spec.swift_version = '5.0'

  spec.source_files  = "KYNearbyService"
  spec.exclude_files = "KYNearbyService/KYNearbyService.docc"

  spec.requires_arc = true
  
  spec.dependency "KYLogger", "~> 1.0"
end
