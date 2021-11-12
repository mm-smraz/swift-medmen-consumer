source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

use_frameworks!

def shared_pods
#  pod 'Alamofire'
#  pod 'Apollo'
  pod 'SwiftLint'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'ReachabilitySwift'
  pod 'R.swift'
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.5.0'
  pod 'AppAuth'
end

target 'MedMen' do
  shared_pods
end

target 'MedMenQA' do
  shared_pods
end
