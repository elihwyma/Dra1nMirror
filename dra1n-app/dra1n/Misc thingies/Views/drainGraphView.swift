//
//  drainGraphView.swift
//  dra1n
//
//  Created by Amy While on 18/07/2020.
// Gradient between cc3791 and BF8FD4

import Macaw

open class drainGraphView: MacawView {
    
    
    func setTextColourForMacaw(text: Text) -> Text {
        if #available(iOS 13, *) {
            if (self.traitCollection.userInterfaceStyle == .dark) {
                text.fill = Color(val: 0xFFFFFF)
            } else {
                text.fill = Color(val: 0x000000)
            }
        } else {
            text.fill = Color(val: 0xFFFFFF)
        }
        return text
    }

    public var emptySegmentColour: Color {
        if #available(iOS 13, *) {
            if (self.traitCollection.userInterfaceStyle == .dark) {
                return Color.rgba(r: 255, g: 255, b: 255, a: 0.1)
            } else {
                return Color.rgba(r: 120, g: 120, b: 120, a: 0.1)
            }
        } else {
            return Color.rgba(r: 255, g: 255, b: 255, a: 0.1)
        }
    }
    
    private var barsGroup = Group()
    private var captionsGroup = Group()
    
    private var barsValues = [Int]()
    private var barsCaptions = [String]()
    private var barsCount = 0
    private var titleText = "\(NSLocalizedString("averageBatteryDrain", comment: ""))"
    private let barSegmentsCount = 10
    private let barsSpacing = 25
    private let segmentWidth = 40
    private let segmentHeight = 10
    private let segmentsSpacing = 10
        
    private let barSegmentColors = [
        0xA778D5,
        0xAB71CD,
        0xAF6AC6,
        0xB362BE,
        0xB75BB7,
        0xBC54AF,
        0xC04DA8,
        0xC445A0,
        0xC83E99,
        0xCC3791
    ].map {
        Color(val: $0)
    }
    
    private func createBars(centerX: Double, isEmpty: Bool) -> Group {
        let barsGroup = Group()
        barsGroup.place = Transform.move(dx: centerX, dy: 90)
        for barIndex in 0...barsCount - 1 {
            let barGroup = Group()
            barGroup.place = Transform.move(dx: Double((barsSpacing + segmentWidth) * barIndex), dy: 0)
            for segmentIndex in 0...barSegmentsCount - 1 {
                barGroup.contents.append(createSegment(segmentIndex: segmentIndex, isEmpty: isEmpty))
            }
            barGroup.contents.reverse()
            barsGroup.contents.append(barGroup)
        }
        return barsGroup
    }

    private func createSegment(segmentIndex: Int, isEmpty: Bool) -> Shape {
        return Shape(
            form: RoundRect(
                rect: Rect(
                    x: 0,
                    y: Double((segmentHeight + segmentsSpacing) * segmentIndex),
                    w: Double(segmentWidth),
                    h: Double(segmentHeight)
                ),
                rx: Double(segmentHeight),
                ry: Double(segmentHeight)
            ),
            fill: isEmpty ? emptySegmentColour : barSegmentColors[segmentIndex],
            opacity: isEmpty ? 1 : 0
        )
    }
    
    private func createScene() {
        let viewCenterX = Double(self.frame.width / 2)
        
        var text = Text(
            text: titleText,
            font: Font(name: "System", size: 24),
            fill: Color(val: 0xFFFFFF)
        )
        
        text.align = .mid
        text.place = .move(dx: viewCenterX, dy: 30)
        text = setTextColourForMacaw(text: text)
        
        let barsWidth = Double((segmentWidth * barsCount) + (barsSpacing * (barsCount - 1)))
        let barsCenterX = viewCenterX - barsWidth / 2
        
        let barsBackgroundGroup = createBars(centerX: barsCenterX, isEmpty: true)
        barsGroup = createBars(centerX: barsCenterX, isEmpty: false)
        
        captionsGroup = Group()
        captionsGroup.place = Transform.move(
            dx: barsCenterX,
            dy: 100 + Double((segmentHeight + segmentsSpacing) * barSegmentsCount)
        )
        for barIndex in 0...barsCount - 1 {
            var text = Text(
                text: barsCaptions[barIndex],
                font: Font(name: "System", size: 14),
                fill: Color(val: 0xFFFFFF)
            )
            text.align = .mid
            text.place = .move(dx: Double((barsSpacing + segmentWidth) * barIndex + (segmentWidth / 2)), dy: 0)
            text = setTextColourForMacaw(text: text)
            captionsGroup.contents.append(text)
        }
        
        self.node = [text, barsGroup, barsBackgroundGroup, captionsGroup].group()
    }
    
    private func unHideBars() {
        barsGroup.contents.enumerated().forEach { nodeIndex, node in
            if let barGroup = node as? Group {
                let barSize = self.barsValues[nodeIndex]
                barGroup.contents.enumerated().forEach { barNodeIndex, barNode in
                    if let segmentShape = barNode as? Shape, barNodeIndex <= barSize - 1 {
                        segmentShape.opacity = 1
                    }
                }
            }
        }
    }
    
    func organiseTheData() -> Bool {
        var array = CepheiController.getObject(key: "DrainAvarageLog") as? [[String : Any]] ?? [[String : Any]]()
        
        barsValues = [Int]()
        barsCaptions = [String]()
    
        if ((array.count == 0)) { return false }
        
        var barCountCase = CepheiController.getInt(key: "BarCount")
        if barCountCase == 0 {
            barCountCase = 5
        }
   
        if (array.count > barCountCase) { array = Array(array.suffix(barCountCase)) }
        barsCount = array.count
            
        var tempArray = [Int]()
            
        for item in array {
            let dict = item
            let drain = dict["drain"] as? Int ?? 0
            tempArray.append(abs(drain))
        }
        let sensitivity: Double
        tempArray.sort()
        let numberInQuestion = tempArray[tempArray.count - 1]
        if (numberInQuestion > 750) {
            sensitivity = 1
        } else if (numberInQuestion > 500) {
            sensitivity = 1.5
        } else if (numberInQuestion > 250) {
            sensitivity = 2
        } else {
            sensitivity = 4
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"
        
        let data2 = DateFormatter()
        data2.locale = NSLocale.current
        data2.dateFormat = Dra1nController.dayMonthFormat ? "MM/dd" : "dd/MM"

        for item in array {
            let dict = item
            let drain = dict["drain"] as? Int ?? 0
            let dividedBy100: Double = abs(Double(drain) / Double(100))
            let multiplied: Double = dividedBy100 * sensitivity
            var roundedDrain: Int = Int(multiplied.rounded())
            if (roundedDrain > 10) { roundedDrain = 10 }
            let date = dict["time"]
            let convertedDate = dateFormatter.string(from: date as! Date)
            let date2 = data2.string(from: date as! Date)
            
            barsValues.append(roundedDrain)
            barsCaptions.append("\(drain)mA \n \(convertedDate) \n \(date2)")
        }
       
        return true
    }
   
    open func play() {
        self.contentMode = .scaleAspectFit
  
        if(!organiseTheData()) {
            titleText = "\(NSLocalizedString("noAveragesYet", comment: ""))"
            barsCount = 1
            barsValues.append(1)
            barsCaptions.append("😐")
        }
        createScene()
        unHideBars()
 
    }
    
}
