#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "SNLInteractionTableView"
  s.version          = "1.3.0"
  s.summary          = "Complete tableView stack (controller, tableView and cell) to easily add more interaction to your tableView."
  s.description      = <<-DESC
                       SNLInteractionTableView provides a complete tableView stack (controller, tableView and cell) to easily add more interaction to your tableView. It uses AutoLayout and extends an existing tableViewCell layout from your Storyboard with the following functionality:

                        * Swipe Action - left and right, with bounce, slide-back or slide-out animation
                        * Selection - with toolbar
                        * Reordering - by long press
                       DESC
  s.homepage         = "http://simonnickel.de/devlog/projects/sninteractiontableview"
  s.screenshots      = "http://simonnickel.de/wp-content/uploads/2014/02/snifinal1.gif"
  s.license          = 'MIT'
  s.author           = { "Simon Nickel" => "simonnickel@googlemail.com" }
  s.source           = { :git => "https://github.com/simonnickel/SNLInteractionTableView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/simonnickel_en'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/ios/*.{h,m}'
  s.resources = 'Assets/*.gif'

end
