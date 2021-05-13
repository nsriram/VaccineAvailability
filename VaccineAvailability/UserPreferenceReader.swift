import Cocoa
import os.log

class UserPreferenceReader {
  let filename:URL
  let defaultPreference:String = "{\"pincodes\" : [\"600001\", \"400001\", \"110001\"], \"lessThan45\" : false}"

  init(){
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    self.filename = paths[0].appendingPathComponent("preferences.json")
  }
  
  func write(fileContent: String) {
    do {
      try fileContent.write(to: self.filename, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      let errorInfo = "Could not write to \(self.filename)"
      os_log("%@", errorInfo)
      let errorDetails = "\(error)"
      os_log("%@", errorDetails)
    }
  }
  
  func read() -> String {
    if !FileManager.default.fileExists(atPath: self.filename.path) {
      os_log("File does not exist")
      write(fileContent: defaultPreference)
      return defaultPreference
    }
    var contents = ""
    do {
      contents = try String(contentsOfFile: self.filename.path)
    } catch {
      let errorInfo = "Could not load \(self.filename)"
      os_log("%@", errorInfo)
      let errorDetails = "\(error)"
      os_log("%@", errorDetails)
    }
    return contents
  }
}
