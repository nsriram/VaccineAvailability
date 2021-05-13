import Foundation

class Hospital {
  var hospitalName:String
  var address: String
  var stateName: String
  var districtName: String
  var blockName: String
  var pincode: Int
  var feeType: String
  var sessions: [Session]
  
  init(hospitalName:String,
       address:String,
       stateName: String,
       districtName: String,
       blockName:String,
       pincode: Int,
       feeType: String,
       sessions:[Session]){
    self.hospitalName = hospitalName
    self.address = address
    self.stateName = stateName
    self.districtName = districtName
    self.blockName = blockName
    self.pincode = pincode
    self.feeType = feeType
    self.sessions = sessions
  }
  
  func isAvailableFor(ageLimit: Int) -> Bool {
    let filteredSessions = self.sessions.filter ({$0.isAvailableFor(ageLimit: ageLimit)})
    return filteredSessions.count > 0
  }
  
  func formattedDate() -> String {
    return self.sessions.map ({$0.date}).joined(separator: ", ")
  }

  func daysAvailable(ageLimit: Int) -> String {
    return "\(self.sessions.count) days available (Age \(ageLimit) and above)"
  }
}
