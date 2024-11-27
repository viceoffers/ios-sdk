  
Pod::Spec.new do |s|
    s.name             = 'ViceTracking'
    s.version          = '1.0.0'
    s.summary          = 'Mobile app tracking SDK for ViceOffers'
    s.description      = <<-DESC
  ViceTracking SDK allows you to track app installs and events in your iOS applications.
  Easily integrate with the ViceOffers affiliate network.
                         DESC
  
    s.homepage         = 'https://github.com/viceoffers/ios-sdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'ViceOffers' => 'support@viceoffers.com' }
    s.source           = { :git => 'https://github.com/viceoffers/ios-sdk.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '11.0'
    s.swift_version = '5.0'
  
    s.source_files = 'Sources/ViceTracking/**/*'
    
    s.frameworks = 'Foundation', 'AdSupport', 'AppTrackingTransparency'
  end