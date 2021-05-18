import Foundation
class Session {
  var date:String
  var vaccine:String
  var availableCapacity: Int
  var availableCapacityDose1: Int
  var availableCapacityDose2: Int
  var ageLimit:Int
  
  init(date:String,
       vaccine:String,
       availableCapacity: Int,
       availableCapacityDose1: Int,
       availableCapacityDose2: Int,
       ageLimit:Int){
    self.date = date
    self.vaccine = vaccine
    self.availableCapacity = availableCapacity
    self.availableCapacityDose1 = availableCapacityDose1
    self.availableCapacityDose2 = availableCapacityDose2
    self.ageLimit = ageLimit
  }
  
  func isAvailableFor(ageLimit: Int, dosage1: Bool, dosage2:Bool) -> Bool {
    if(!dosage1 && !dosage2){
      return false
    }

    if(dosage1 && dosage2){
      return self.availableCapacity > 0 && self.ageLimit <= ageLimit
    }
    var dose1Available = true
    var dose2Available = false
    if(dosage1) {
      dose1Available = self.availableCapacityDose1 > 0
    }
    if(dosage2) {
      dose2Available = self.availableCapacityDose2 > 0
    }
    return self.availableCapacity > 0 && self.ageLimit <= ageLimit && dose1Available && dose2Available
  }
}
