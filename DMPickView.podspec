Pod::Spec.new do |s|
s.name         = "DMPickView"
  s.version      = "0.0.4"
  s.summary      = "A pickview for daima."
  s.description  = <<-DESC
                    a pickview for array ,string and dictionary
                   DESC

  s.homepage     = "https://github.com/jun860605/DMPickView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "郑军" => "junzheng3@creditease.cn" }
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/jun860605/DMPickView.git", :tag => s.version }
  s.source_files  = "Classes/*.{h,m}"
  s.dependency  "Masonry"
  s.resources = "Classes/*.png"
end
