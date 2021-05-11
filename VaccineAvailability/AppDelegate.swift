import Cocoa
import SwiftUI
import Alamofire

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!
  var timer = Timer()
  let cowinAPIServer:String = "https://cdn-api.co-vin.in"
  let pincodeAPIURI:String = "/api/v2/appointment/sessions/public/findByPin"
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
    if let statusButton = statusItem.button {
      statusButton.target = self
      statusButton.image =  NSImage(named:"HospitalAvailabilityIcon")
      statusButton.action = #selector(exitMenu(sender:))
      statusButton.sendAction(on: [.rightMouseUp, .rightMouseDown])
      self.updateClock()
    }
    timer = Timer.scheduledTimer(timeInterval: 10,
                                 target: self,
                                 selector: #selector(updateClock),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  @objc func updateClock() {
    let button = statusItem.button
    let headers: HTTPHeaders = [
        "Accept-Language": "en_US",
        "accept": "application/json"
    ]
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "IST")
    dateFormatter.dateFormat = "dd-MM-YYYY"
    let today:String = dateFormatter.string(from: Date())
    let requestURL = "\(cowinAPIServer)\(pincodeAPIURI)?pincode=600062&date=\(today)"
    NSLog(requestURL)
    AF.request(requestURL, headers: headers).responseJSON { response in
      debugPrint(response)
    }
    button?.title = dateFormatter.string(from: Date())
  }
  
  @objc func exitMenu(sender: NSStatusBarButton) {
    let menu = NSMenu()
    menu.addItem(NSMenuItem(title: "Exit",
                            action: #selector(self.exitApp(sender:)),
                            keyEquivalent: "Q"))
    statusItem.menu = menu
  }

  @objc func exitApp(sender: AnyObject){
      NSApplication.shared.terminate(sender)
  }
}
