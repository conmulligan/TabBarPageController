#
# Be sure to run `pod lib lint TabBarPageController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TabBarPageController'
  s.version          = '0.1.0'
  s.summary          = 'A container view controller that manages paging navigation between tabs of content.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A container view controller that manages navigation between tabs of content. Each tab is managed by a child view controller embedded in a UIPageViewController instance, allowing users to navigate between tabs by selecting tab bar items or swiping left and right.
                       DESC

  s.homepage         = 'https://github.com/conmulligan/TabBarPageController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'conmulligan' => 'conmulligan@gmail.com' }
  s.source           = { :git => 'https://github.com/conmulligan/TabBarPageController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'TabBarPageController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TabBarPageController' => ['TabBarPageController/Assets/*.png']
  # }

  s.frameworks = 'UIKit'
end
