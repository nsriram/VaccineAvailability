import Foundation
import SwiftyJSON

class SessionsParser {
  init(){
  }
  
  func parse(sessionsResponse : Any) -> [Session] {
    let json = JSON(sessionsResponse)
    var availableSessions:[Session] = []
    let sessions: JSON = json["sessions"]
    if(!sessions.isEmpty){
      for (_, session):(String, JSON) in sessions {
        let hospitalName = session["name"].stringValue
        let address = session["address"].stringValue
        let stateName = session["state_name"].stringValue
        let districtName = session["district_name"].stringValue
        let pincode = session["pincode"].intValue
        let vaccine = session["vaccine"].stringValue
        let availableCapacity = session["available_capacity"].intValue
        let ageLimit = session["min_age_limit"].intValue
        let availableSession:Session = Session(hospitalName: hospitalName, address: address, stateName: stateName, districtName: districtName, pincode: pincode, vaccine: vaccine, availableCapacity: availableCapacity, ageLimit: ageLimit)
        availableSessions.append(availableSession)
      }
    }
    return availableSessions
  }
}
