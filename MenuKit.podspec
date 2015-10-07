Pod::Spec.new do |s|

  s.name         = 'MenuKit'
  s.version      = '0.6.0'
  s.summary      = 'Objective-C menu and order framework optimized for encoding into barcodes.'
  s.description  = <<-DESC
                   This project provides an implementation of a menu domain model and menu
                   ordering framework that is designed with encoding orders into 2D barcodes. 
                   DESC

  s.homepage     = 'https://github.com/Blue-Rocket/BRMenu'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE.txt' }
  s.author       = { 'Matt Magoffin' => 'matt@bluerocket.us' }

  s.platform     = :ios, '8.4'

  s.source       = { :git => 'https://github.com/Blue-Rocket/BRMenu.git', 
  					 :tag => s.version.to_s }
  
  s.requires_arc = true
  
  s.default_subspecs = 'All'
  
  s.subspec 'All' do |sp|
    sp.source_files = 'Menu/Code/MenuKit.h'
    sp.dependency 'MenuKit/Core'
    sp.dependency 'MenuKit/RestKit'
	sp.dependency 'MenuKit/AFNetworking'
	sp.dependency 'MenuKit/UI'
  end
  
  s.subspec 'Core' do |sp|
  	sp.source_files = 'Menu/Code/Core.h', 'Menu/Code/Core'
    sp.dependency 'CocoaLumberjack', '~> 2.0'
	sp.dependency 'BRStyle/Core',    '~> 0.10.0'
    sp.resource_bundle = { 'BRMenu' => 'Menu/Resources/Core/**' }
  end
  
  s.subspec 'RestKit' do |sp|
    sp.source_files = 'Menu/Code/RestKit.h', 'Menu/Code/RestKit'
    sp.dependency 'MenuKit/Core'
    sp.dependency 'RestKit/ObjectMapping', '~> 0.24'
  end
  
  s.subspec 'AFNetworking' do |sp|
    sp.source_files = 'Menu/Code/AFNetworking.h', 'Menu/Code/AFNetworking'
    sp.dependency 'MenuKit/RestKit'
    sp.dependency 'AFNetworking', '~> 2.5'
  end
  
  s.subspec 'UI' do |sp|
    sp.source_files = 'Menu/Code/UI.h', 'Menu/Code/UI'
    sp.dependency 'MenuKit/Core'
	sp.dependency 'BRLocalize/Core', '~> 0.9'
    sp.dependency 'BRPDFImage',      '~> 1.0'
	sp.dependency 'Masonry',         '~> 0.6'
    sp.resource_bundle = { 'BRMenuUI' => 'Menu/Resources/UI/**/*.{storyboard,lproj,pdf}' }
  end
  
end
