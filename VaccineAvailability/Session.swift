import Foundation
class Session {
  var hospitalName:String
  var address: String
  var stateName: String
  var districtName: String
  var pincode: Int
  var vaccine:String
  var availableCapacity: Int
  var ageLimit:Int
  
  init(hospitalName:String,
       address:String,
       stateName: String,
       districtName: String,
       pincode: Int,
       vaccine:String,
       availableCapacity: Int,
       ageLimit:Int){
    self.hospitalName = hospitalName
    self.address = address
    self.stateName = stateName
    self.districtName = districtName
    self.pincode = pincode
    self.vaccine = vaccine
    self.availableCapacity = availableCapacity
    self.ageLimit = ageLimit
  }
  
  func isAvailableFor(ageLimit: Int) -> Bool {
    return self.availableCapacity > 0 && self.ageLimit <= ageLimit
  }
}
