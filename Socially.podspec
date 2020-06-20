Pod::Spec.new do |s|
  s.name             = 'Socially'
  s.version          = '0.0.2'
  s.summary          = 'Social Sign-In for SwiftUI'
  s.description      = <<-DESC
Socially provides the easiest way to integrate Social Sign-In in iOS app using SwiftUI
                       DESC

  s.homepage         = 'https://github.com/phoelapyae69/Socially'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Phoe Lapyae' => 'phoelapyayt7@gmail.com' }
  s.source           = { :git => 'https://github.com/phoelapyae69/Socially.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/phoelapyaeX_X'
  s.ios.deployment_target = '13.0'
  s.source_files = 'Socially/Classes/**/*'
  s.swift_version = '5.2'
  s.static_framework = true
  s.subspec 'Google' do |google|
      google.source_files = 'Socially/Classes/Google/*', 'Socially/Classes/SociallyAuth/*'
      google.dependency 'GoogleSignIn', '~> 5.0'
  end
  s.subspec 'Facebook' do |facebook|
      facebook.source_files = 'Socially/Classes/Facebook/*', 'Socially/Classes/SociallyAuth/*'
      facebook.dependency 'FBSDKLoginKit', '~> 7.0'
  end
  # s.resource_bundles = {
  #   'Socially' => ['Socially/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
