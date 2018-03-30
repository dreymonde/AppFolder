Pod::Spec.new do |s|
  s.name         = "AppFolder"
  s.version      = "0.2.0"
  s.summary      = "Never use NSSearchPathForDirectoriesInDomains again. Never."
  s.description  = <<-DESC
    Your app folder structure. Friendly and strongly-typed. Friendly API for "Documents/", "Library/Caches/", "Library/Application Support", "tmp/" and any other directory you create.
  DESC
  s.homepage     = "https://github.com/dreymonde/AppFolder"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Oleg Dreyman" => "dreymonde@me.com" }
  s.social_media_url   = "https://twitter.com/olegdreyman"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/dreymonde/AppFolder.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
