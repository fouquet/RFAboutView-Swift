Pod::Spec.new do |s|
  s.name             = "RFAboutView-Swift"
  s.version          = "2.0.0"
  s.summary          = "A drop-in 'about view' offering information about an app, the pods used and diagnostic debug information."
  s.description      = <<-DESC
**RFAboutView** is an easy, drop-in solution to display copyright, support, privacy and other information while also automatically crediting the developers of third-party Cocoapods. RFAboutView uses AutoLayout and can be used both for iPhone and iPad apps.

Its main features are:

* Displays app name and copyright information.
* Displays an optional link to a website, opening in Safari.
* Displays an optional link to an Email address.
* If the user clicks on the Email link, a `MFMailComposeViewController` opens, (optionally) pre-filled with diagnostic information useful for support: App name and version, current device, current iOS version, preferred device language.
* Displays additional buttons with further information (for example your TOS or Privacy Policy) that you can specify.
* Displays acknowledgements for all Cocoapods used in the project. The acknowledgements file automatically created by Cocoapods is used for this, requiring almost no work on your part. See the "Automatic acknowledgements" below for more information.
* Clean and modern design with lots of customisation options.
                        DESC
  s.homepage         = "https://github.com/fouquet/RFAboutView-Swift"
s.screenshots      = "https://fouquet.me/RFAboutView/screenshot1.png", "https://fouquet.me/RFAboutView/screenshot2.png", "https://fouquet.me/RFAboutView/screenshot3.png"
  s.license          = 'MIT'
  s.author           = { "René Fouquet" => "mail@fouquet.me" }
  s.source           = { :git => "https://github.com/fouquet/RFAboutView-Swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/renefouquet'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'RFAboutView_Swift' => ['Pod/Assets/*.png']
  }
end
