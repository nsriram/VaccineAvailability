import SwiftUI
import Cocoa
import os.log
import SwiftyJSON

struct ContentView: View {
  @State private var pincode1 = ""
  @State private var pincode2 = ""
  @State private var pincode3 = ""
  @State private var lessThan45 = false
  @State private var popover:NSPopover!
  
  init(pincode1: Int, pincode2 : Int, pincode3 : Int, popover:NSPopover, lessThan45:Bool) {
    _pincode1 = State(initialValue: "\(pincode1)")
    _pincode2 = State(initialValue: "\(pincode2)")
    _pincode3 = State(initialValue: "\(pincode3)")
    _popover = State(initialValue: popover)
    _lessThan45 = State(initialValue: lessThan45)
  }
  
  func isPincode(pincode: String) -> Bool {
    return Int(pincode) != nil && Int(pincode)! > 100000 && Int(pincode)! < 1000000
  }
  
  var body: some View {
    VStack {
      VStack{
        Section (header :
                  Text("Vaccine Availability")
                  .frame(width: 200)
                  .font(.title3)
        ){}
      }
      .padding(EdgeInsets(top: 10, leading:20, bottom: 10, trailing: 20))
      .background(Color(red: 0.18, green: 0.18, blue: 0.18))
      
      HStack{
        Toggle(" Include 18-44 Age Group ? ", isOn: $lessThan45)
          .padding(EdgeInsets(top: 10, leading:10, bottom: 0, trailing: 10))
      }
      
      Divider()
      
      HStack{
        Image("Location")
          .resizable()
          .scaledToFit()
          .frame(width: 16.0, height: 16.0, alignment: .leading)
        Text("Pincode(s)")
          .font(.title2)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(EdgeInsets(top: 2, leading:0, bottom: 0, trailing: 10))
      }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))
      
      VStack{
        TextField("Pincode 1 (6 digits)",text: $pincode1,
                  onCommit: {
                    if(!isPincode(pincode: pincode1)){
                      self.pincode1 = "0"
                    }
                  })
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(EdgeInsets(top: 10, leading:10, bottom: 0, trailing: 10))
        
        TextField("Pincode 2 (6 digits)",text: $pincode2,
                  onCommit: {
                    if(!isPincode(pincode: pincode2)){
                      self.pincode2 = "0"
                    }
                  })
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(EdgeInsets(top: 10, leading:10, bottom: 0, trailing: 10))
        
        TextField("Pincode 3 (6 digits)",text: $pincode3,
                  onCommit: {
                    if(!isPincode(pincode: pincode3)){
                      self.pincode3 = "0"
                    }
                  })
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(EdgeInsets(top: 10, leading:10, bottom: 0, trailing: 10))
        
        Button(action: savePreferences) {
          HStack{
            Text("Save Preferences")
              .font(.title3)
          }
        }
        .buttonStyle(GradientButtonStyle())
        .padding(EdgeInsets(top: 5, leading:0, bottom: 5, trailing: 0))
        
        Divider()
        Button(action: exitApp) {
          HStack{
            Text("Exit App")
              .font(.title2)
          }
        }
        .buttonStyle(GradientButtonStyle2())
        .padding(EdgeInsets(top: 0, leading:0, bottom: 5, trailing: 0))
      }
      
    }.background(Color(red: 0.15, green: 0.15, blue: 0.15))
  }
  
  func savePreferences(){
    let preferenceJsonString = "{\"pincodes\" : [\(pincode1), \(pincode2), \(pincode3)], \"lessThan45\" : \(lessThan45)}"
    let userPreferenceReader = UserPreferenceReader()
    userPreferenceReader.write(fileContent: preferenceJsonString)
    self.popover.performClose(self)
  }
  
  func exitApp(){
    NSApplication.shared.terminate(self)
  }
  
  struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .foregroundColor(Color.white)
        .frame(width: 160, height: 30)
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.20, green: 0.47, blue: 0.65)]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(5.0)
    }
  }
  
  struct GradientButtonStyle2: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .foregroundColor(Color.white)
        .frame(width: 240, height: 30)
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.15, green: 0.15, blue: 0.15)]), startPoint: .leading, endPoint: .trailing))
    }
  }
  
  struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
    }
  }
}
