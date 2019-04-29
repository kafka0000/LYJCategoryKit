#
# Be sure to run `pod lib lint LYJUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LYJCategoryKit'
  s.version          = '1'
  s.summary          = 'category组件'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kafka0000/LYJCategoryKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vinci' => 'kafka673@gmail.com' }
  s.source           = { :git => 'https://github.com/kafka0000', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LYJUtils/Classes/**/*'
  
end
