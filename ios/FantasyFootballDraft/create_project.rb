#!/usr/bin/env ruby

require 'xcodeproj'

# Create a new Xcode project
project_path = 'FantasyFootballDraft.xcodeproj'
project = Xcodeproj::Project.new(project_path)

# Add a build configuration
project.build_configurations.each { |config| config.name }
debug_config = project.build_configurations.first
debug_config.name = 'Debug'
release_config = project.build_configurations.last || project.build_configurations.new
release_config.name = 'Release'

# Create the main target
target = project.new_target(:application, 'FantasyFootballDraft', :ios)
target.product_type = 'com.apple.product-type.application'
target.deployment_target = '15.0'

# Configure build settings
target.build_configurations.each do |config|
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
  config.build_settings['SWIFT_VERSION'] = '5.9'
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.yourcompany.FantasyFootballDraft'
  config.build_settings['PRODUCT_NAME'] = '$(TARGET_NAME)'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '2'  # iPad only
  config.build_settings['SUPPORTED_PLATFORMS'] = 'iphoneos'
  
  if config.name == 'Debug'
    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
  elsif config.name == 'Release'
    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-O'
  end
end

# Save the project
project.save

puts "✅ Created #{project_path}"
puts "✅ Created target: FantasyFootballDraft"
puts "✅ Deployment target: iOS 15.0"
puts ""
puts "Next step: cd FantasyFootballDraft && pod install"
