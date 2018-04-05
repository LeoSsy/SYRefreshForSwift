Pod::Spec.new do |s|
s.name         = 'SYRefresh'
s.summary      = 'Powerful text framework for iOS to Refresh.'
s.version      = '1.0.5'
s.swift_version = "4.0"
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = { 'ssy' => '781739973@qq.com' }
s.social_media_url = 'https://github.com/LeoVessel'
s.homepage     = 'https://github.com/LeoVessel/SYRefreshForSwift.git'
s.platform     = :ios, '8.0'
s.ios.deployment_target = '8.0'
s.source       = { :git => 'https://github.com/LeoVessel/SYRefreshForSwift.git', :tag => s.version.to_s }
s.source_files  = ["SYRefresh/*.swift", "SYRefresh/SYRefresh.h", "SYRefresh/RefreshView.swift"]

s.requires_arc = true
end



