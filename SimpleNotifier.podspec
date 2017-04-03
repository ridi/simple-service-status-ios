Pod::Spec.new do |spec|
  spec.name             = 'SimpleNotifier'
  spec.version          = '0.1.0'
  spec.authors          = { 'Ridibooks Viewer Team' => 'viewer.team@ridi.com' }
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/ridibooks/simple-notifier-ios'
  spec.source           = { :git => 'https://github.com/ridibooks/simple-notifier-ios.git', :tag => spec.version }
  spec.summary          = 'Simple notifier SDK for iOS'
  spec.screenshot       = 'https://github.com/ridibooks/simple-notifier-ios/blob/master/screenshot-demo.png'

  spec.platform         = :ios
  spec.ios.deployment_target = '8.0'

  spec.dependency 'Alamofire', '~> 4.0'
  spec.dependency 'SwiftyUserDefaults', '~> 3.0.0'

  spec.source_files     = 'SimpleNotifier/Classes/**/*'
end
