#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_paytabs_bridge_emulator.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_paytabs_bridge_emulator'
  s.version          = '1.0.1-beta'
  s.summary          = 'PayTabs bridge emulator'
  s.description      = <<-DESC
Paytabs is a payment gateway
                       DESC
  s.homepage         = 'http://paytabs.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'PayTabs' => 'm.adly@paytabs.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'PayTabs', '4.1.1'
  s.platform = :ios, '9.0'
  s.static_framework = true
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
