//
//  ContentView.swift
//  Swift 3D Knob
//
//  Created by Eddy Salzmann on 25.11.20.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack{
            Swift3DKnob(start: 0, width: 200, height: 200, minVal: 0, maxVal: 127, speed: 0.5)
            Text("Speed 0.5")
            Swift3DKnob(start: 60, width: 200, height: 200, minVal: 0, maxVal: 127, speed: 1)
            Text("Speed 1")
            Swift3DKnob(start: 104, width: 200, height: 200, minVal: 0, maxVal: 127, speed: 1.5)
            Text("Speed 1.5")
        }
    }
}

struct Swift3DKnob : View{
    
    // Init values
    var start: Int
    var width: CGFloat
    var height: CGFloat
    var minVal: Int
    var maxVal: Int
    var speed: Double
    
    // Global values
    @State private var index = 0
    @State private var lastX : CGFloat = 0
    @State private var lastY : CGFloat = 0
    
    private let images = (0...127).map { UIImage(named: "knob_\($0).jpg")! }
    
    // Handle drag rotate
    var drag: some Gesture {
        DragGesture()
            .onChanged {value in
                
                //Horizontal movement
                if value.translation.width > lastX {
                    
                    if index + Int(Double(value.translation.width - lastX) * speed) < maxVal {
                        index += Int(Double(value.translation.width - lastX) * speed)
                    }
                }else{
                    if index - Int(Double(lastX - value.translation.width) * speed) > minVal {
                        index -= Int(Double(lastX - value.translation.width) * speed)
                    }
                }
                
                // Vertical movement
                if value.translation.height > lastY {
                    
                    if index - Int(Double(value.translation.height - lastY) * speed) > minVal {
                        index -= Int(Double(value.translation.height - lastY) * speed)
                    }
                }else{
                    if index + Int(Double(lastY - value.translation.height) * speed) < maxVal {
                        index += Int(Double(lastY - value.translation.height) * speed)
                    }
                }

                lastY = value.translation.height
                lastX = value.translation.width
            }
            .onEnded { value in
                lastX = 0
                lastY = 0
            }
    }
    
    
    // Output
    var body: some View {
        
        Image(uiImage: images[index])
            .resizable()
            .frame(width: width, height: height, alignment: .center)
            .gesture(drag)
            .onAppear{
                if start <= maxVal && start >= minVal {
                    index = start
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
