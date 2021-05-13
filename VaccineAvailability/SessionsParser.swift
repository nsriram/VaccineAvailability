import Foundation
import SwiftyJSON

class SessionsParser {
  init(){}
  
  func parse(calendarResponse : Any) -> [Hospital] {
    var availableHospitals:[Hospital] = []
    let json = JSON(calendarResponse)
    let centers: JSON = json["centers"]
    if(!centers.isEmpty){
      for (_, center):(String, JSON) in centers {
        let hospitalName = center["name"].stringValue
        let address = center["address"].stringValue
        let stateName = center["state_name"].stringValue
        let districtName = center["district_name"].stringValue
        let blockName = center["block_name"].stringValue
        let pincode = center["pincode"].intValue
        let feeType = center["feeType"].stringValue


        var availableSessions:[Session] = []
        let sessions: JSON = center["sessions"]
        for (_, session):(String, JSON) in sessions {
          let date = session["date"].stringValue
          let vaccine = session["vaccine"].stringValue
          let availableCapacity  = session["available_capacity"].intValue
          let ageLimit  = session["min_age_limit"].intValue
          let availableSession = Session(date:date,
                                         vaccine:vaccine,
                                         availableCapacity: availableCapacity,
                                         ageLimit:ageLimit)
          availableSessions.append(availableSession)
        }

        let availableHospital:Hospital = Hospital(hospitalName: hospitalName,
                                                  address: address,
                                                  stateName: stateName,
                                                  districtName: districtName,
                                                  blockName: blockName,
                                                  pincode: pincode,
                                                  feeType: feeType,
                                                  sessions:availableSessions)
        availableHospitals.append(availableHospital)
      }
    }
    return availableHospitals
  }
}
