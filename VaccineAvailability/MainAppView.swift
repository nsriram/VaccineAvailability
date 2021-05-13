import SwiftUI
import SwiftyJSON

struct MainAppView: View {
  struct GradientButtonStyle2: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .foregroundColor(Color.white)
        .frame(width: 160, height: 30)
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.20, green: 0.47, blue: 0.65)]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(5.0)
    }
  }
  
  func gotoCowinRegistration(){
    NSWorkspace.shared.open(URL(string: "https://selfregistration.cowin.gov.in/")!)
  }
  
  var body: some View {
    VStack (alignment: .leading){
      HStack{
        Image("HospitalAvailability")
          .resizable()
          .scaledToFit()
          .frame(width: 32.0, height: 32.0, alignment: .leading)
        Text("Vaccine Availability Tracker")
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.title)
      }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))
      Divider()
      VStack (alignment: .leading){
        Text("Configure using 'menu bar icon' and receive availability notifications.")
          .font(.title2)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(EdgeInsets(top: 5, leading:10, bottom: 0, trailing: 10))

        HStack{
          Image("Notification")
            .resizable()
            .scaledToFit()
            .frame(width: 24.0, height: 24.0, alignment: .leading)
          Text("You can configure Age Limit & up to 3 Pincodes")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 2, leading:10, bottom: 0, trailing: 10))
        }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))

        HStack{
          Image("Notification")
            .resizable()
            .scaledToFit()
            .frame(width: 24.0, height: 24.0, alignment: .leading)
          Text("You will receive notifications if there are slots available for the pincode and age limit configured.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 2, leading:10, bottom: 0, trailing: 10))
        }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))

        Divider()
        Button(action: gotoCowinRegistration) {
          HStack{
            Text("Book Vaccine Slot")
              .font(.title3)
          }
        }
        .padding()
        .buttonStyle(GradientButtonStyle2())
        .frame(maxWidth: .infinity, alignment: .center)
      }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))
    }
    .frame(width: 320, height: 340)
  }
}
