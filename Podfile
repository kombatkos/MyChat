# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Firebase/Firestore', '7.8'
  pod 'SwiftLint'

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
       end
   end
end

  # Pods for DemoFireBase2

end