source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "8.0"

target "onruby" do
  pod "AFNetworking",         "2.4.1"
  pod "MMMarkdown",           "0.3"
  pod "CrashlyticsFramework", "2.2.4"
  pod "ZeroPush",             "2.0.2"
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-onruby/Pods-onruby-acknowledgements.plist', 'onruby/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
