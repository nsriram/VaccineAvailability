import Foundation
class Session {
  var date:String
  var vaccine:String
  var availableCapacity: Int
  var ageLimit:Int
  
  init(date:String,
       vaccine:String,
       availableCapacity: Int,
       ageLimit:Int){
    self.date = date
    self.vaccine = vaccine
    self.availableCapacity = availableCapacity
    self.ageLimit = ageLimit
  }
  
  func isAvailableFor(ageLimit: Int) -> Bool {
    return self.availableCapacity > 0 && self.ageLimit <= ageLimit
  }
}
