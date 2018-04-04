#
#  Be sure to run `pod spec lint SYRefresh.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
  s.name         = "SYRefresh"
  s.version      = "1.0.0"
  s.summary      = "简单易用的刷新框架"
  s.description  =  "ios refresh框架 支持scrollview,tableview,collectionview刷新,同时支持collectionview水平刷新功能"
  s.homepage     = "https://github.com/LeoVessel/SYRefreshForSwift.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "ssy" => "781739973@qq.com" }
  # Or just: s.author    = "ssy"
  # s.authors            = { "ssy" => "781739973@qq.com" }
  # s.social_media_url   = "http://twitter.com/ssy"
  s.source       = { :git => "https://github.com/LeoVessel/SYRefreshForSwift.git", :tag => "#{s.version}" }
  s.source_files = 'SYRefreshForSwift/**/*.{h,m}'
  # s.exclude_files = "SYRefreshForSwift/"
  s.public_header_files='SYRefreshForSwift/**/*.{h}'
end
