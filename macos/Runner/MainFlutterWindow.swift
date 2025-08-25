import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    // Configure window to be hidden at launch to avoid black screen
    self.isOpaque = false
    self.backgroundColor = NSColor.clear
    flutterViewController.backgroundColor = NSColor.clear

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
