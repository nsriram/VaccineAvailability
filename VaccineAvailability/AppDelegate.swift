import Cocoa
import SwiftUI
import UserNotifications
import Alamofire
import SwiftyJSON

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!
  var popover:NSPopover!
  var timer = Timer()

  let center = UNUserNotificationCenter.current()

  var pincode1:String = ""
  var pincode2:String = ""

  let cowinAPIServer:String = "https://cdn-api.co-vin.in"
  let pincodeAPIURI:String = "/api/v2/appointment/sessions/public/findByPin"
  
  func loadPreferences() {
    let userPreferenceReader = UserPreferenceReader()
    let config = userPreferenceReader.read()
    let json = JSON(config.data(using: .utf8, allowLossyConversion: true)!)
    let pincodes: JSON = json["pincodes"]
    self.pincode1 = "\(pincodes[0].intValue)"
    self.pincode2 = "\(pincodes[1].intValue)"
    print(self.pincode1)
    print(self.pincode2)
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      if granted {
        print("Access Granted")
      } else {
        print("Access Not Granted")
      }
    }
    self.statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
    
    loadPreferences();
    let contentView = ContentView(pincode1: self.pincode1, pincode2: self.pincode2)

    let popover = NSPopover()
    popover.contentSize = NSSize(width: 200, height: 400)
    popover.behavior = .transient
    popover.contentViewController = NSHostingController(rootView: contentView)
    self.popover = popover
    
    self.statusItem.button?.image = NSImage(named: "HospitalAvailability")
    self.statusItem.button?.action = #selector(togglePopover(_:))
    
    self.updateClock()
    timer = Timer.scheduledTimer(timeInterval: 30,
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
    loadPreferences();
    let requestURL = "\(cowinAPIServer)\(pincodeAPIURI)?pincode=\(self.pincode1)&date=\(today)"
    var title:String = "No Sessions"
    
    print(requestURL)
    
    AF.request(requestURL, headers: headers).responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        let sessions: JSON = json["sessions"]
        if(!sessions.isEmpty){
          //First session parsing
          let firstSession:JSON = sessions[1]
          title = firstSession["name"].stringValue
          let stateName = firstSession["state_name"].stringValue
          let districtName = firstSession["district_name"].stringValue
          print(title)
          
          //Notification
          let content = UNMutableNotificationContent()
          content.title = title
          content.body = "\(districtName),\(stateName)"
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2,
                                                          repeats: false)
          let request = UNNotificationRequest(identifier: UUID().uuidString,
                                              content: content,
                                              trigger: trigger)
          self.center.add(request)
        }
      case .failure(let error):
        print(error)
        button?.title = title
      }
    }
  }
  
  func addExitMenu() {
    let menuItem = NSMenuItem(title: "Exit",
                              action: #selector(self.exitApp),
                              keyEquivalent: "Q")
    menuItem.target = self
    statusItem.menu?.addItem(menuItem)
  }
  
  @objc func exitApp(sender: AnyObject){
    NSApplication.shared.terminate(sender)
  }
  
  @objc func togglePopover(_ sender: AnyObject?) {
    if let button = self.statusItem.button {
      if self.popover.isShown {
        self.popover.performClose(sender)
      } else {
        self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }
  }
}
