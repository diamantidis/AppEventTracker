Pod::Spec.new do |s|
    s.name             = 'AppEventTracker'
    s.version          = '1.0.0'
    s.summary          = 'AppEventTracker is an iOS library to automatically track various events.'
    s.description      = <<-DESC
    AppEventTracker is an iOS library to automatically track various events by injecting code to different functions, like for example `viewDidLoad`.
    DESC

    s.homepage         = 'https://github.com/diamantidis/AppEventTracker'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'diamantidis' => 'diamantidis@outlook.com' }
    s.source           = { :git => 'https://github.com/diamantidis/AppEventTracker.git', :tag => s.version.to_s }
    s.ios.deployment_target = '9.3'
    s.swift_version    = '4.2'
    s.source_files     = 'AppEventTracker/Classes/**/*'
end
