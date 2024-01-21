//
//  MotionUpdateHandler.swift
//  BaTest
//
//  Created by Safa Şık on 03.12.23.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject{
    @Published var motionManager = CMMotionManager()
    @Published var rotationAngle: Double = 0
    @Published var leftAngle: Double = 0
    @Published var rightAngle: Double = 0
    @Published var tmpRightAngle: Double = 0
    @Published var tmpLeftAngle: Double = 0
    @Published var maxAngle: Double = 0
    @Published var dispatchWorkItemRight: DispatchWorkItem?
    @Published var dispatchWorkItemLeft: DispatchWorkItem?
    @Published var roll: Double = 0
    @Published var getLeftRight: String = ""
    @Published var calibrationOffset: Double = 0
    
    func resetMaxAngle() {
        self.maxAngle = 0
    }
    
    func resetCalibration() {
        self.calibrationOffset = 0
    }

    func calibrateOrientation() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available.")
            return
        }

        if let attitude = motionManager.deviceMotion?.attitude {

            self.calibrationOffset = attitude.roll * 180 / .pi

            self.tmpLeftAngle = 0
            self.tmpRightAngle = 0
        }
    }

    func relativeRotationAngle() -> Double {
        guard let attitude = motionManager.deviceMotion?.attitude else {
            return 0
        }
        return (attitude.roll * 180 / .pi) - calibrationOffset
    }
    
    func startMotionUpdates() {
          if motionManager.isDeviceMotionAvailable {
              motionManager.deviceMotionUpdateInterval = 0.1
              motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                  self.rotationAngle = self.relativeRotationAngle()

                  
                  if abs(self.maxAngle) <= abs(self.rotationAngle) { self.maxAngle = self.rotationAngle }
                  if self.maxAngle < 0 { self.getLeftRight = "L" } else { self.getLeftRight = "R" }
                  if self.rotationAngle > 0 {
                      self.rightAngle = self.rotationAngle
                      if self.tmpRightAngle < self.rotationAngle {
                          self.cancelDispatchTaskRight()
                          self.tmpRightAngle = self.rotationAngle
                      }
                      if self.tmpRightAngle > self.rotationAngle{
                          self.startDispatchTaskRight()
                      }
                  }
                  if self.rotationAngle < 0{
                      self.leftAngle = self.rotationAngle
                      if self.tmpLeftAngle > self.rotationAngle {
                          self.cancelDispatchTaskLeft()
                          self.tmpLeftAngle = self.rotationAngle
                      }
                      if self.tmpLeftAngle < self.rotationAngle{
                          self.startDispatchTaskLeft()
                      }
                  }
              }
          }
      }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func startDispatchTaskRight() {
        let workItem = DispatchWorkItem {
            if self.rotationAngle < 0 {self.tmpRightAngle = 0}
            else {self.tmpRightAngle = self.rotationAngle}
        }

        dispatchWorkItemRight = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }

    func cancelDispatchTaskRight() {
        if let workItem = dispatchWorkItemRight {
            workItem.cancel()
        }
    }

    func startDispatchTaskLeft() {
        let workItem = DispatchWorkItem {
            if self.rotationAngle > 0 {self.tmpLeftAngle = 0}
            else {self.tmpLeftAngle = self.rotationAngle}
        }

        dispatchWorkItemLeft = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }

    func cancelDispatchTaskLeft() {
        if let workItem = dispatchWorkItemLeft {
            workItem.cancel()
        }
    }
}

