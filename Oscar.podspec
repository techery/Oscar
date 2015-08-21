#
# Be sure to run `pod lib lint Oscar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Oscar"
  s.version          = "0.1.0"
  s.summary          = "Actor programming model framework"

  s.description      = ""

  s.homepage         = "https://github.com/techery/Oscar"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Techery" => "opensource@techery.io" }
  s.source           = { :git => "https://github.com/Techery/Oscar.git", :tag => 1.0 }
  s.social_media_url = 'https://techery.io'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Oscar' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'RXPromise', '~> 0.13'
end
