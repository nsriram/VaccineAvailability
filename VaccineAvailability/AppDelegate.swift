import Cocoa
import SwiftUI
import UserNotifications
import Alamofire
import SwiftyJSON
import os.log

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!
  var popover:NSPopover!
  var timer = Timer()
  var sessionsParser:SessionsParser!
  
  let center = UNUserNotificationCenter.current()
  
  var pincode1:Int = 600001
  var pincode2:Int = 400001
  var pincode3:Int = 110001

  var lessThan45:Bool = false
  var dosage1:Bool = true
  var dosage2:Bool = false

  
  let cowinAPIServer:String = "https://cdn-api.co-vin.in"
  let pincodeAPIURI:String = "/api/v2/appointment/sessions/public/calendarByPin"
  
  func loadPreferences() {
    let userPreferenceReader = UserPreferenceReader()
    let config = userPreferenceReader.read()
    let json = JSON(config.data(using: .utf8, allowLossyConversion: true)!)

    let pincodes: JSON = json["pincodes"]
    self.pincode1 = pincodes[0].intValue
    self.pincode2 = pincodes[1].intValue
    self.pincode3 = pincodes[2].intValue

    let lessThan45 = json["lessThan45"]
    self.lessThan45 = lessThan45.boolValue

    let dosage1 = json["dosage1"]
    self.dosage1 = dosage1.boolValue

    let dosage2 = json["dosage2"]
    self.dosage2 = dosage2.boolValue
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.sessionsParser = SessionsParser()
    loadPreferences();

    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      if granted {
        os_log("Access Granted")
      } else {
        os_log("Access Not Granted")
      }
    }

    let popover = NSPopover()
    popover.contentSize = NSSize(width: 200, height: 400)
    popover.behavior = .transient
    self.popover = popover
    
    self.statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
    let contentView = ContentView(pincode1: self.pincode1,
                                  pincode2: self.pincode2,
                                  pincode3: self.pincode3,
                                  popover : self.popover,
                                  lessThan45: self.lessThan45,
                                  dosage1: dosage1,
                                  dosage2: dosage2)
    self.popover.contentViewController = NSHostingController(rootView: contentView)
    self.statusItem.button?.image = NSImage(named: "HospitalAvailability")
    self.statusItem.button?.action = #selector(togglePopover(_:))
    
    self.updateClock()
    timer = Timer.scheduledTimer(timeInterval: 10,
                                 target: self,
                                 selector: #selector(updateClock),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  func addNotification(hospital:Hospital, ageLimit:Int, dosage1: Bool, dosage2 : Bool){
    let content = UNMutableNotificationContent()
    content.title = "\(hospital.hospitalName), \(hospital.districtName)"

    let daysAvailabe:[String] = hospital.daysAvailable(ageLimit: ageLimit, dosage1: dosage1, dosage2: dosage2)
    let subtitle = "\(daysAvailabe.count) day(s) available (Age \(ageLimit) and above)"
    
    content.subtitle = subtitle
    content.body = daysAvailabe.joined(separator: ", ")

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString,
                                        content: content,
                                        trigger: trigger)
    self.center.add(request)
  }
  
  @objc func updateClock() {
    loadPreferences();
    let headers: HTTPHeaders = [
      "Accept-Language": "en_US",
      "accept": "application/json"
    ]
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "IST")
    dateFormatter.dateFormat = "dd-MM-YYYY"
    let today:String = dateFormatter.string(from: Date())
    let ageLimit = self.lessThan45 ? 18 : 45

    for pincode:Int in [self.pincode1, self.pincode2, self.pincode3] {
      let requestURL = "\(cowinAPIServer)\(pincodeAPIURI)?pincode=\(pincode)&date=\(today)"
      AF.request(requestURL, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let value):
          let hospitals:[Hospital] = self.sessionsParser.parse(calendarResponse: value)
          for hospital in hospitals {
            if(hospital.isAvailableFor(ageLimit: ageLimit,
                                       dosage1: self.dosage1,
                                       dosage2: self.dosage2)){
              self.addNotification(hospital:hospital,
                                   ageLimit: ageLimit,
                                   dosage1: self.dosage1,
                                   dosage2: self.dosage2)
              }
          }
        case .failure(let error):
          let errorDetails = "\(error)"
          os_log("%@", errorDetails)
        }
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
