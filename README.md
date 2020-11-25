Swift 3D Knob
===

Simple image squencer for rotating 3D knobs.

## How it works
This technique is based on an image sequence that gets triggered as soon as somebody drags the knob around. You can also adjust this for other interfaces like faders etc. To create your buttons you need to create a bunch of images that rotate from left to right in a continuous sequence. I eg used C4D to generate the knob in the example, starting from frame 0 to 127, and rotated the knob in that time from 127° to -127°. The number of image steps you need is defined by the "minVal" and "maxVal" in your initial setup for the button. The rendered image sequences can then be added to the assets folder and used right away. Your assets should be named like this:

```
knob_0.jpg
knob_1.jpg
knob_2.jpg
...
knob_127.jpg
```

## Code
```swift
struct Swift3DButton : View{
    
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
```

## Usage
```swift
struct ContentView: View {

    var body: some View {
        VStack{
            Swift3DButton(start: 0, width: 200, height: 200, minVal: 0, maxVal: 127, speed: 0.5)
            Text("Speed 0.5")
            Swift3DButton(start: 60, width: 200, height: 200, minVal: 0, maxVal: 127, speed: 1)
            Text("Speed 1")
            Swift3DButton(start: 104, width: 200, height: 200, minVal: 0, maxVal: 127, speed: 1.5)
            Text("Speed 1.5")
        }
    }
}
```


<img width="400" src="https://github.com/eddysalzmann/Swift-3d-Knob/blob/main/swift-3d-knob.png?raw=true">
