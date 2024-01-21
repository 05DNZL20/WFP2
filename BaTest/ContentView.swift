//
//  ContentView.swift
//  BaTest
//
//  Created by Safa Şık on 19.11.23.
//

import SwiftUI
import CoreLocation
import CoreMotion


struct ContentView: View {
    @ObservedObject private var locationViewModel = LocationViewModel()
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Button("Calibrate") {
                        motionManager.calibrateOrientation()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .offset(x:-90,y:-230)
                    
                    Button("Reset") {
                        motionManager.resetMaxAngle()
                        locationViewModel.resetDistanceAndTopSpeed()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .offset(x:90,y:-230)
                }
                Text("0°")
                    .foregroundStyle(.white)
                    .offset(x:0,y:-193)
                
                Text("20°")
                    .foregroundStyle(.white)
                    .offset(x:-64,y:-180)
                
                Text("20°")
                    .foregroundStyle(.white)
                    .offset(x:66,y:-180)
                
                Text("40°")
                    .foregroundStyle(.white)
                    .offset(x:-125,y:-146)
                
                Text("40°")
                    .foregroundStyle(.white)
                    .offset(x:128,y:-146)
                
                Text("60°")
                    .foregroundStyle(.white)
                    .offset(x:-168,y:-96)
                
                Text("60°")
                    .foregroundStyle(.white)
                    .offset(x:172,y:-96)
                
                Image("Motorrad")
                    //.frame(width: 360.71, height: 360)
                    .rotationEffect(.degrees(motionManager.rotationAngle))
                
                Image("Ring-Angle")
                    //.frame(width: 220, height: 220)
                
                Image("Tilt Angle")
                    //.frame(width: 220, height: 220)
                
                Image("Needle")
                    //.frame(width: 220, height: 220)
                    .rotationEffect(.degrees(motionManager.rotationAngle))
                
                Text("\(motionManager.getLeftRight) Max:\n\(abs(motionManager.maxAngle), specifier: "%.0f")°")
                    .multilineTextAlignment(.center)
                    .font(.system(size:24))
                    .foregroundColor(Color.white)
                    .offset(x:0,y: -115)
                
                
                Text("Links:\n\(abs(motionManager.tmpLeftAngle), specifier: "%.0f")°")
                    .multilineTextAlignment(.center)
                    .font(.system(size:24))
                    .foregroundColor(Color.white)
                    .offset(x:-90,y: 75)
                
                Text("Rechts:\n\(motionManager.tmpRightAngle, specifier: "%.0f")°")
                    .multilineTextAlignment(.center)
                    .font(.system(size:24))
                    .foregroundColor(Color.white)
                    .offset(x: 85,y: 75)
            }
            .onAppear {
                motionManager.startMotionUpdates()
            }
            .onDisappear {
                motionManager.stopMotionUpdates()
            }
            ZStack{
                Image("Speed-Design")
                
                Text("\(locationViewModel.speed * 3.6 ,specifier: "%0.0f")")
                    .font(Font.custom("DS-Digital", size: 140))
                    .foregroundColor(Color.green)
                    .offset(x:-45, y:-35)
                
                Text("KM/H")
                    .font(Font.custom("DS-Digital", size: 40))
                    .foregroundColor(Color.green)
                    .offset(x:110, y:0)
                
                Text("Top Speed:")
                    .font(Font.custom("DS-Digital", size: 30))
                    .foregroundColor(Color.green)
                    .offset(x: -75,y: 40)
                
                Text("\(locationViewModel.maxSpeed * 3.6, specifier: "%0.0f")")
                    .font(Font.custom("DS-Digital", size: 30))
                    .foregroundColor(Color.green)
                    .offset(x: -118.5,y: 70)
                
                Text("KM/H")
                    .font(Font.custom("DS-Digital", size: 30))
                    .foregroundColor(Color.green)
                    .offset(x:-60, y: 70)
                
                Text("Range:")
                    .font(Font.custom("DS-Digital", size: 30))
                    .foregroundColor(Color.green)
                    .offset(x:95, y:40)
                
                Text("\(locationViewModel.totalDistance,specifier: "%0.1f") KM")
                    .font(Font.custom("DS-Digital", size: 30))
                    .foregroundColor(Color.green)
                    .offset(x: 96, y: 70)
                
                Text("Ø:")
                    .font(Font.custom("DS-Digital", size: 30))
                    .foregroundColor(Color.green)
                    .offset(x: -30, y:-130)
                
                Text("\(locationViewModel.averageSpeed * 3.6,specifier: "%0.0f") KM/H")
                    .font(Font.custom("DS-Digital", size: 30))
                    .foregroundColor(Color.green)
                    .offset(x: 30, y: -130)
                
                Button("Reset calibration") {
                    motionManager.resetCalibration()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .offset(x:0,y:165)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background {
             LinearGradient(gradient: Gradient(colors: [Color(red: 0.10, green: 0.10, blue: 0.10), Color(red: 0.14, green: 0.14, blue: 0.14), Color(red: 0.24, green: 0.24, blue: 0.24)]), startPoint: .top, endPoint: .bottom)
                 .ignoresSafeArea()
         }
    }
}

#Preview {
    ContentView()
}
