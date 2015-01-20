source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "8.0"

target "onruby" do
  pod "AFNetworking",         "2.5.0"
  pod "MMMarkdown",           "0.4"
  pod "CrashlyticsFramework", "2.2.5.2"
  pod "ZeroPush",             "2.0.3"
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-onruby/Pods-onruby-acknowledgements.plist', 'onruby/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
