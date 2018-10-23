Pod::Spec.new do |s|
  s.name             = 'TabBarPageController'
  s.version          = '0.1.4'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'A container view controller that manages navigation between pages of content using a tab bar.'
  s.homepage         = 'https://github.com/conmulligan/TabBarPageController'
  s.author           = { 'conmulligan' => 'conmulligan@gmail.com' }
  s.source           = { :git => 'https://github.com/conmulligan/TabBarPageController.git', :tag => s.version.to_s }
  s.screenshots     = 'https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/1.png', 'https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/2.png', 'https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/3.png'
  s.social_media_url = 'https://twitter.com/conmulligan'

  s.swift_version = '4.2'
  s.ios.deployment_target = '9.0'

  s.source_files = 'TabBarPageController/Classes/**/*'

  s.frameworks = 'UIKit'
  
  s.description = <<-DESC
    A container view controller that manages navigation between pages of content. Each page is represented by a child view controller embedded in a UIPageViewController instance, allowing users to navigate between pages by either selecting tab bar items or swiping left and right.
  DESC
end
