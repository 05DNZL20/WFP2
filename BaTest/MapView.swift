import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
     @ObservedObject private var locationViewModel = LocationViewModel()
     
     let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
     
     
      var body: some View {
         VStack {
             Map() {
                 UserAnnotation()
             }
             .mapControls {
                 MapUserLocationButton()
             }
             
              Text("Speed: \(locationViewModel.speed * 3.6, specifier: "%.2f") km/h")
              
              Text(locationViewModel.log)
            }
         }
     }
#Preview
{
    MapView()
}

