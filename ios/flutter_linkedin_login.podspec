#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_linkedin_login'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '10.0'

  s.preserve_paths = 'linkedin-sdk.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework linkedin-sdk' }
  s.frameworks = 'linkedin-sdk'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '/Users/gigivu/IdeaProjects/flutter_linkedin_login/ios/linkedin-sdk.framework' }
  s.vendored_frameworks = 'linkedin-sdk.framework'
end

