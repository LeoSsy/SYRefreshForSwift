Pod::Spec.new do |s|
s.name         = 'SYRefresh'
s.summary      = 'Small and flexibly refresh framework for iOS UIScrollview.'
s.version      = '1.1.0'
s.swift_version = "4.0"
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = { 'ssy' => '781739973@qq.com' }
s.social_media_url = 'https://github.com/LeoVessel'
s.homepage     = 'https://github.com/LeoVessel/SYRefreshForSwift.git'
s.platform     = :ios, '8.0'
s.ios.deployment_target = '8.0'
s.source       = { :git => 'https://github.com/LeoVessel/SYRefreshForSwift.git', :tag => s.version.to_s }
s.source_files = 'SYRefresh/*.swift'
s.frameworks   = "UIKit", "Foundation","CoreText","CoreGraphics","ImageIO" #支持的框架
s.requires_arc = true
end



