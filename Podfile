# Uncomment the next line to define a global platform for your project

platform :ios, '13.0'

target 'Acela' do
	# Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!
	pod 'HMSegmentedControl'
	pod 'MBProgressHUD'
	pod 'MarkdownView'
	pod 'SDWebImage'
	pod 'SwiftDate'
	# Pods for Acela

end


post_install do |installer|
	installer.generated_projects.each do |project|
		project.targets.each do |target|
			target.build_configurations.each do |config|
				config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
			end
		end
	end
end
