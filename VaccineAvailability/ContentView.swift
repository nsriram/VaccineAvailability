import SwiftUI
import Cocoa
import os.log
import SwiftyJSON

//extension ContentView  {
//  init(pincode1: String, pincode2 : String) {
//    self.pincode1 = pincode1
//    self.pincode2 = pincode2
//  }
//}

struct ContentView: View {
  @State private var pincode1 = ""
  @State private var pincode2 = ""
  
  init(pincode1: String, pincode2 : String) {
    _pincode1 = State(initialValue: pincode1)
    _pincode2 = State(initialValue: pincode2)
  }

  func savePreferences(){
    let preferenceJsonString = "{\"pincodes\" : [\(pincode1), \(pincode2)]}"
    print("saving")
    print(preferenceJsonString)
    let userPreferenceReader = UserPreferenceReader()
    userPreferenceReader.write(fileContent: preferenceJsonString)
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
  
  var body: some View {
    VStack {
      VStack{
        Section (header :
                  Text("Vaccine Availability")
                  .frame(width: 200)
                  .font(.title3)
        ){
        }
      }
      .padding(EdgeInsets(top: 10, leading:20, bottom: 10, trailing: 20))
      .background(Color(red: 0.18, green: 0.18, blue: 0.18))
      
      TextField("Pincode 1",text: $pincode1)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(EdgeInsets(top: 10, leading:10, bottom: 0, trailing: 10))
      
      
      TextField("Pincode 2",text: $pincode2)
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
          Text("Exit Application")
            .font(.title3)
        }
      }
      .buttonStyle(GradientButtonStyle2())
      .padding(EdgeInsets(top: 0, leading:0, bottom: 5, trailing: 0))
      
    }.background(Color(red: 0.15, green: 0.15, blue: 0.15))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(pincode1: "600061", pincode2: "600096")
  }
}
