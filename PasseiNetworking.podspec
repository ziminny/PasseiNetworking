Pod::Spec.new do |s|
  s.name                  = 'PasseiNetworking'
  s.version               = '0.0.2'
  s.summary               = 'Rest api'
  s.swift_version         = '5.0'
  s.description           = <<-DESC "Describe the use of pod file"
  Rest api framework
  DESC
  s.homepage              = 'https://github.com/ziminny/PasseiNetworking'
  s.license               = { :type => 'PASSEI-GROUP', :file => 'LICENSE' }
  s.authors               = { 'Vagner Oliveira' => 'ziminny@gmail.com' }
  s.source                = { :git => 'https://github.com/ziminny/PasseiNetworking.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.6'
  s.osx.deployment_target = '13.0'
  s.source_files          = 'PasseiNetworking/Classes/**/*' 
  s.dependency 'PasseiLogManager'
  s.dependency 'PasseiSecurity'
  s.dependency 'Socket.IO-Client-Swift'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'PasseiNetworking/Tests/**/*.{swift,h,m}'
    test_spec.framework = 'XCTest'
  end

  end
