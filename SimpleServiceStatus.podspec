Pod::Spec.new do |spec|
  spec.name             = 'SimpleServiceStatus'
  spec.version          = '1.1.0'
  spec.authors          = { 'Ridibooks Viewer Team' => 'viewer.team@ridi.com' }
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/ridi/simple-service-status-ios'
  spec.source           = { :git => 'https://github.com/ridi/simple-service-status-ios.git', :tag => spec.version }
  spec.summary          = 'SimpleServiceStatus SDK for iOS'
  spec.screenshot       = 'https://raw.githubusercontent.com/ridi/simple-service-status-ios/master/screenshot-demo.png'

  spec.platform         = :ios
  spec.ios.deployment_target = '8.0'

  spec.dependency 'Alamofire', '~> 4.7'
  spec.dependency 'SwiftyUserDefaults', '~> 3.0.0'

  spec.source_files     = 'SimpleServiceStatus/Classes/**/*'
end
