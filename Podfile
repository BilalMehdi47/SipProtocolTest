# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'
source "https://gitlab.linphone.org/BC/public/podspec.git"
#source "https://github.com/CocoaPods/Specs.git"

def basic_pods
	if ENV['PODFILE_PATH'].nil?
		pod 'linphone-sdk', '~> 5.2.66'
	else
		pod 'linphone-sdk', :path => ENV['PODFILE_PATH']  # local sdk
	end
	
end



target 'SipTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for IncomingCall
  basic_pods

end