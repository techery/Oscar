#
# Be sure to run `pod lib lint Oscar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Oscar"
  s.version          = "1.0.4"
  s.summary          = "Actor programming model framework"

  s.description      = "The actor model in computer science is a mathematical model of concurrent computation that treats \"actors\" as the universal primitives of concurrent computation: in response to a message that it receives, an actor can make local decisions, create more actors, send more messages, and determine how to respond to the next message received.(Wikipedia)"

  s.homepage         = "https://github.com/techery/Oscar"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Techery" => "opensource@techery.io" }
  s.source           = { :git => "https://github.com/Techery/Oscar.git", :tag => s.version }
  s.social_media_url = 'http://techery.io'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'RXPromise', '~> 0.13'
  s.dependency   'CocoaLumberjack'
end
