//
//  ViewController.swift
//  ColorDial
//
//  Created by Kenneth Allan on 30/11/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

// swiftlint:disable file_length

import Cocoa

// swiftlint:disable:next type_body_length
class ViewController: NSViewController, ColorSupplyDelegate, NSWindowDelegate, NSTextFieldDelegate {
    var rValue: Int {
        get { return Int(round(rFloat.isNaN ? 0 : rFloat * 255)) }
        set { rFloat = clamp(CGFloat(newValue) / 255) }
    }
    var gValue: Int {
        get { return Int(round(gFloat.isNaN ? 0 : gFloat * 255)) }
        set { gFloat = clamp(CGFloat(newValue) / 255) }
    }
    var bValue: Int {
        get { return Int(round(bFloat.isNaN ? 0 : bFloat * 255)) }
        set { bFloat = clamp(CGFloat(newValue) / 255) }
    }
    var hValue: Int {
        get { return Int(round(hFloat.isNaN ? 0 : hFloat * 360)) }
        set { hFloat = clamp(CGFloat(newValue) / 360) }
    }
    var sValue: Int {
        get { return Int(round(sFloat.isNaN ? 0 : sFloat * 100)) }
        set { sFloat = clamp(CGFloat(newValue) / 100) }
    }
    var vValue: Int {
        get { return Int(round(vFloat.isNaN ? 0 : vFloat * 100)) }
        set { vFloat = clamp(CGFloat(newValue) / 100) }
    }
    
    var rFloat: CGFloat = 0
    var gFloat: CGFloat = 0
    var bFloat: CGFloat = 0
    var hFloat: CGFloat = 0
    var sFloat: CGFloat = 0
    var vFloat: CGFloat = 0
    
    var color: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    var lockedColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    var textBgColor: NSColor!
    var pickerWin: NSWindow!
    var picker: Picker!
    var harmony = "analogous"
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var colorWell: NSColorWell!
    @IBOutlet weak var tipLabel: NSTextField!
    
    @IBOutlet weak var rSlider: NSSlider!
    @IBOutlet weak var gSlider: NSSlider!
    @IBOutlet weak var bSlider: NSSlider!
    @IBOutlet weak var hSlider: NSSlider!
    @IBOutlet weak var sSlider: NSSlider!
    @IBOutlet weak var vSlider: NSSlider!

    @IBOutlet weak var rText: NSTextField!
    @IBOutlet weak var gText: NSTextField!
    @IBOutlet weak var bText: NSTextField!
    @IBOutlet weak var hText: NSTextField!
    @IBOutlet weak var sText: NSTextField!
    @IBOutlet weak var vText: NSTextField!
    
    @IBOutlet weak var rStepper: NSStepper!
    @IBOutlet weak var gStepper: NSStepper!
    @IBOutlet weak var bStepper: NSStepper!
    @IBOutlet weak var hStepper: NSStepper!
    @IBOutlet weak var sStepper: NSStepper!
    @IBOutlet weak var vStepper: NSStepper!
    
    @IBOutlet weak var rSliderCell: ColorSlider!
    @IBOutlet weak var gSliderCell: ColorSlider!
    @IBOutlet weak var bSliderCell: ColorSlider!
    @IBOutlet weak var hSliderCell: ColorSlider!
    @IBOutlet weak var sSliderCell: ColorSlider!
    @IBOutlet weak var vSliderCell: ColorSlider!
    
    @IBOutlet weak var cc0: ColorCircle!
    @IBOutlet weak var cc30: ColorCircle!
    @IBOutlet weak var cc60: ColorCircle!
    @IBOutlet weak var cc90: ColorCircle!
    @IBOutlet weak var cc120: ColorCircle!
    @IBOutlet weak var cc150: ColorCircle!
    @IBOutlet weak var cc180: ColorCircle!
    @IBOutlet weak var cc210: ColorCircle!
    @IBOutlet weak var cc240: ColorCircle!
    @IBOutlet weak var cc270: ColorCircle!
    @IBOutlet weak var cc300: ColorCircle!
    @IBOutlet weak var cc330: ColorCircle!
    @IBOutlet weak var ccPlus: ColorCircle!
    @IBOutlet weak var ccMinus: ColorCircle!
    @IBOutlet weak var ccDown: ColorCircle!
    @IBOutlet weak var ccUp: ColorCircle!

    @IBOutlet weak var cc1: ColorCircle!
    @IBOutlet weak var cc2: ColorCircle!
    @IBOutlet weak var cc3: ColorCircle!
    @IBOutlet weak var cc4: ColorCircle!
    @IBOutlet weak var cc5: ColorCircle!

    var cch = [ColorCircle?](repeating: nil, count: 14)
    @IBOutlet weak var cch1: ColorCircle!
    @IBOutlet weak var cch2: ColorCircle!
    @IBOutlet weak var cch3: ColorCircle!
    @IBOutlet weak var cch4: ColorCircle!
    @IBOutlet weak var cch5: ColorCircle!
    @IBOutlet weak var cch6: ColorCircle!
    @IBOutlet weak var cch7: ColorCircle!
    @IBOutlet weak var cch8: ColorCircle!
    @IBOutlet weak var cch9: ColorCircle!
    @IBOutlet weak var cch10: ColorCircle!
    @IBOutlet weak var cch11: ColorCircle!
    @IBOutlet weak var cch12: ColorCircle!
    @IBOutlet weak var cch13: ColorCircle!
    @IBOutlet weak var cch14: ColorCircle!

    @IBOutlet weak var hexText: NSTextField!
    @IBOutlet weak var rgbText: NSTextField!
    @IBOutlet weak var hslText: NSTextField!
    
    @IBOutlet weak var eyeDropper: NSButton!
    
    @IBOutlet weak var analogousHarmony: NSButton!
    @IBOutlet weak var compoundHarmony: NSButton!
    @IBOutlet weak var triadicHarmony: NSButton!
    @IBOutlet weak var complementaryHarmony: NSButton!
    @IBOutlet weak var shadesHarmony: NSButton!
    @IBOutlet weak var monochromaticHarmony: NSButton!
    
    @IBOutlet weak var lockButton: NSButton!
    @IBOutlet weak var modeButton: NSButton!
    
    func flashPress(_ item: NSView, _ flash: CGFloat = 0.3, _ dur: CGFloat = 1.2) {
        NSAnimationContext.current.duration = Double(dur)
        item.alphaValue = flash
        item.animator().alphaValue = 1
    }
    
    @IBAction func eyeDropper(_ sender: NSButton) {
        flashPress(sender)

        tipLabel.stringValue = "⌘-click when picking to pick multiple colors at once, press escape to close picker."
        picker.picking = true
        pickerWin.makeKeyAndOrderFront(pickerWin)
        NSCursor.hide()
    }
    
    @IBAction func hexCopy(_ sender: NSButton) {
        flashPress(sender)
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.writeObjects([hexText.stringValue as NSPasteboardWriting])
    }
    
    @IBAction func rgbCopy(_ sender: NSButton) {
        flashPress(sender)
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.writeObjects([rgbText.stringValue as NSPasteboardWriting])
    }
    
    @IBAction func hslCopy(_ sender: NSButton) {
        flashPress(sender)
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.writeObjects([hslText.stringValue as NSPasteboardWriting])
    }
    
    @IBAction func colorUpdated(_ sender: AnyObject) {
        if let cw = sender as? NSColorWell {
            color = cw.color
            setFromColor()
        }
    }
    
    @IBAction func lockPressed(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            sender.title = "🔓"
            lockedColor = color
            setSliders()
        } else {
            sender.title = "🔒"
        }
    }
    
    func setModeIcon() {
        if modeButton.state.rawValue == 1 {
            modeButton.title = "🎨"
        } else {
            modeButton.title = "📐"
        }
    }
    
    @IBAction func modePressed(_ sender: NSButton) {
        setModeIcon()
        defaults.set(sender.state.rawValue == 0, forKey: "scientificMode")
        
        setSliders()
    }
    
    @IBAction func harmonyPressed(_ sender: NSButton) {
        switch sender {
        case complementaryHarmony:
            harmony = "complementary"
            break
        case monochromaticHarmony:
            harmony = "monochromatic"
            break
        case analogousHarmony:
            harmony = "analogous"
            break
        case compoundHarmony:
            harmony = "compound"
            break
        case triadicHarmony:
            harmony = "triadic"
            break
        case shadesHarmony:
            harmony = "shades"
            break
        default:
            break
        }
        
        complementaryHarmony.state = convertToNSControlStateValue(0)
        monochromaticHarmony.state = convertToNSControlStateValue(0)
        analogousHarmony.state = convertToNSControlStateValue(0)
        compoundHarmony.state = convertToNSControlStateValue(0)
        triadicHarmony.state = convertToNSControlStateValue(0)
        shadesHarmony.state = convertToNSControlStateValue(0)
        complementaryHarmony.alphaValue = 0.8
        monochromaticHarmony.alphaValue = 0.8
        analogousHarmony.alphaValue = 0.8
        compoundHarmony.alphaValue = 0.8
        triadicHarmony.alphaValue = 0.8
        shadesHarmony.alphaValue = 0.8
        
        flashPress(sender, 0.8, 0.6)
        sender.state = convertToNSControlStateValue(1)
        setSliders()
    }
    
    var editingTextType: String = ""
    
    var hexPattern: Regex = Regex("^#?([\\da-z]{3}|[\\da-z]{6,})$")
    var rgbPattern: Regex = Regex("([\\d\\.]+),\\s*([\\d\\.]+),\\s*([\\d\\.]+)")
    var hslPattern: Regex = Regex("([\\d\\.]+),\\s*([\\d\\.]+)%?,\\s*([\\d\\.]+)%?")
    
    func controlTextDidChange(_ obj: Notification) {
        if let field = obj.object as? NSTextField {
            inputUpdated(field)
            switch (field) {
            case hexText:
                editingTextType = "hexText"
                break
            case rgbText:
                editingTextType = "rgbText"
                break
            case hslText:
                editingTextType = "hslText"
                break
            default:
                editingTextType = ""
                break
            }
        }
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        editingTextType = ""
    }
    
    override func keyDown(with theEvent: NSEvent) {
        debugPrint("Keydown", theEvent)
        
        if (theEvent.keyCode == 53 && picker.picking) {
            picker.closePicker()
            editingTextType = ""
            hexText.window?.makeFirstResponder(nil)
            hexText.backgroundColor = NSColor.white
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    @IBAction func inputUpdated(_ sender: NSTextField) {
        switch (sender) {
        case rText:
            if rSlider.integerValue == rText.integerValue { return }
            rSlider.integerValue = rText.integerValue
            rValue = clampTo(rSlider.integerValue)
            updateSliders(true)
            break
        case gText:
            if gSlider.integerValue == gText.integerValue { return }
            gSlider.integerValue = gText.integerValue
            gValue = clampTo(gSlider.integerValue)
            updateSliders(true)
            break
        case bText:
            if bSlider.integerValue == bText.integerValue { return }
            bSlider.integerValue = bText.integerValue
            bValue = clampTo(bSlider.integerValue)
            updateSliders(true)
            break
        case hText:
            if hSlider.integerValue == hText.integerValue { return }
            hSlider.integerValue = hText.integerValue
            hValue = clampTo(hSlider.integerValue)
            updateSliders(false)
            break
        case sText:
            if sSlider.integerValue == sText.integerValue { return }
            sSlider.integerValue = sText.integerValue
            sValue = clampTo(sSlider.integerValue)
            updateSliders(false)
            break
        case vText:
            if vSlider.integerValue == vText.integerValue { return }
            vSlider.integerValue = vText.integerValue
            vValue = clampTo(vSlider.integerValue)
            updateSliders(false)
            break
        case rgbText:
            let value = sender.stringValue
            let matches = rgbPattern.match(value)
            
            if matches.count > 0 {
                if let r = Double(matches[0].stringAtRange(value, 1)) {
                    if let g = Double(matches[0].stringAtRange(value, 2)) {
                        if let b = Double(matches[0].stringAtRange(value, 3)) {
                            let rv = clamp(CGFloat(r / 255))
                            let gv = clamp(CGFloat(g / 255))
                            let bv = clamp(CGFloat(b / 255))
                            
                            rgbText.textColor = NSColor.textColor
                            if rv == rFloat && gv == gFloat && bv == bFloat { return }

                            rFloat = rv
                            gFloat = gv
                            bFloat = bv
                            updateSliders(true)
                            return
                        }
                    }
                }
            }
            rgbText.textColor = NSColor(red: 176/255, green: 37/255, blue: 12/255, alpha: 1)
            break
        case hslText:
            let value = sender.stringValue
            let matches = hslPattern.match(value)
            
            if matches.count > 0 {
                if let h = Double(matches[0].stringAtRange(value, 1)) {
                    if let s = Double(matches[0].stringAtRange(value, 2)) {
                        if let l = Double(matches[0].stringAtRange(value, 3)) {
                            let hsl = NSColor.colorWith(clamp(CGFloat(h/360)), saturation: clamp(CGFloat(s/100)), lightness: clamp(CGFloat(l/100)), alpha: 1)
                            
                            let rv = hsl.redComponent
                            let gv = hsl.greenComponent
                            let bv = hsl.blueComponent
                            
                            hslText.textColor = NSColor.textColor
                            if rv == rFloat && gv == gFloat && bv == bFloat { return }

                            rFloat = hsl.redComponent
                            gFloat = hsl.greenComponent
                            bFloat = hsl.blueComponent
                            updateSliders(true)
                            return
                        }
                    }
                }
            }
            hslText.textColor = NSColor(red: 176/255, green: 37/255, blue: 12/255, alpha: 1)
            break
        case hexText:
            let value = sender.stringValue
            let matches = hexPattern.match(value)
            
            if matches.count > 0 {
                let code = matches[0].stringAtRange(value, 1)
                
                if (code.count == 3) {
                    let r = code.hexNibbleAt(0) * 17
                    let g = code.hexNibbleAt(1) * 17
                    let b = code.hexNibbleAt(2) * 17
                    
                    if r == rValue && g == gValue && b == bValue { return }
                    rValue = r
                    gValue = g
                    bValue = b
                    updateSliders(true)
                }
                if (code.count >= 6) {
                    let r = code.hexByteAt(0)
                    let g = code.hexByteAt(2)
                    let b = code.hexByteAt(4)

                    if r == rValue && g == gValue && b == bValue { return }
                    rValue = r
                    gValue = g
                    bValue = b
                    updateSliders(true)
                }
            }
            break
        default:
            break
        }
    }
    
    @IBAction func stepperUpdated(_ sender: NSStepper) {
        editingTextType = ""
        hexText.window?.makeFirstResponder(nil)

        switch (sender) {
        case rStepper:
            if rSlider.integerValue == rStepper.integerValue { return }
            rSlider.integerValue = rStepper.integerValue
            sliderUpdated(rSlider)
            break
        case gStepper:
            if gSlider.integerValue == gStepper.integerValue { return }
            gSlider.integerValue = gStepper.integerValue
            sliderUpdated(gSlider)
            break
        case bStepper:
            if bSlider.integerValue == bStepper.integerValue { return }
            bSlider.integerValue = bStepper.integerValue
            sliderUpdated(bSlider)
            break
        case hStepper:
            if hSlider.integerValue == hStepper.integerValue { return }
            hSlider.integerValue = hStepper.integerValue
            sliderUpdated(hSlider)
            break
        case sStepper:
            if sSlider.integerValue == sStepper.integerValue { return }
            sSlider.integerValue = sStepper.integerValue
            sliderUpdated(sSlider)
            break
        case vStepper:
            if vSlider.integerValue == vStepper.integerValue { return }
            vSlider.integerValue = vStepper.integerValue
            sliderUpdated(vSlider)
            break
        default:
            break
        }
    }
    
    @IBAction func sliderUpdated(_ sender: NSSlider) {
        editingTextType = ""
        hexText.window?.makeFirstResponder(nil)

        var isRGB: Bool = true
        switch (sender) {
        case rSlider:
            rValue = clampTo(rSlider.integerValue)
            break
        case gSlider:
            gValue = clampTo(gSlider.integerValue)
            break
        case bSlider:
            bValue = clampTo(bSlider.integerValue)
            break
        case hSlider:
            hValue = clampTo(hSlider.integerValue, max: 359)
            isRGB = false
            break
        case sSlider:
            sValue = clampTo(sSlider.integerValue, max: 100)
            isRGB = false
            break
        case vSlider:
            vValue = clampTo(vSlider.integerValue, max: 100)
            isRGB = false
            break
        default:
            break
        }
        
        updateSliders(isRGB)
    }
    
    func updateSliders(_ isRGB: Bool) {
        if (isRGB) {
            color = NSColor(red: rFloat, green: gFloat, blue: bFloat, alpha: 1.0)
            hFloat = color.hueComponent
            sFloat = color.saturationComponent
            vFloat = color.brightnessComponent
        } else {
            color = NSColor(hue: hFloat, saturation: sFloat, brightness: vFloat, alpha: 1.0)
            rFloat = color.redComponent
            gFloat = color.greenComponent
            bFloat = color.blueComponent
        }
        
        setSliders()
    }
    
    func colorSupplied(_ supply: NSColor, sender: NSView?) {
        if sender != nil {
            flashPress(sender!)
        }
        editingTextType = ""
        hexText.window?.makeFirstResponder(nil)
        hexText.backgroundColor = NSColor.white
        color = supply
        
        setFromColor()
        
        if (sender is ColorCircle && sender != cc0) { return }
        
        addColorToHistory(color)
    }
    
    func colorSampled(_ sample: NSColor) {
        editingTextType = "hexText"
        hexText.backgroundColor = sample
        let rInt = clampFloatTo(sample.redComponent * 255)
        let gInt = clampFloatTo(sample.greenComponent * 255)
        let bInt = clampFloatTo(sample.blueComponent * 255)
        hexText.stringValue = String(format: "#%02x%02x%02x", rInt, gInt, bInt)
        hexText.window?.makeFirstResponder(nil)
    }
    
    func addColorToHistory(_ add: NSColor) {
        var shuffleFrom = cch.count - 1
        
        if cch1.fill.isEqual(to: add) { return }
        
        for i in 0 ..< shuffleFrom {
            let d = cch[i]!.fill.colorDifference(add)
            if d < 0.001 {
                shuffleFrom = i
                break
            }
        }
        
        if (shuffleFrom == 0) { return }
        
        for j in 1 ... shuffleFrom {
            let i = shuffleFrom - j
            var c: NSColor
            if i > 0 {
                c = cch[i-1]!.fill
            } else {
                c = add
            }
            
            cch[i]!.setColor(c)
            defaults.setNSColor(c, forKey: String(format: "historyColor%d", i+1))
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        exit(0)
    }
    
    override func viewDidAppear() {
        self.view.window!.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedColor = defaults.NSColorForKey("currentColor") {
            color = storedColor
        } else {
            color = NSColor(red: 0.1, green: 0.5, blue: 0.75, alpha: 1)
        }
        
        let scientificMode = defaults.bool(forKey: "scientificMode")
        modeButton.state = NSControl.StateValue(rawValue: scientificMode ? 0 : 1)
        setModeIcon()

        cch[0] = cch1
        cch[1] = cch2
        cch[2] = cch3
        cch[3] = cch4
        cch[4] = cch5
        cch[5] = cch6
        cch[6] = cch7
        cch[7] = cch8
        cch[8] = cch9
        cch[9] = cch10
        cch[10] = cch11
        cch[11] = cch12
        cch[12] = cch13
        cch[13] = cch14
        
        for i in 0 ..< cch.count {
            if let storedColor = defaults.NSColorForKey(String(format: "historyColor%d", i+1)) {
                cch[i]!.setColor(storedColor)
            } else {
                let ii = CGFloat(i)
                cch[i]!.setHSV(15+ii*25, s: 40+ii*6, v: 95-ii*3)
            }
            cch[i]?.delegate = self
            cch[i]?.changeShapeToSquare()
        }
        
        colorWell.color = color
        
        cc0.delegate = self
        cc30.delegate = self
        cc60.delegate = self
        cc90.delegate = self
        cc120.delegate = self
        cc150.delegate = self
        cc180.delegate = self
        cc210.delegate = self
        cc240.delegate = self
        cc270.delegate = self
        cc300.delegate = self
        cc330.delegate = self
        
        ccUp.delegate = self
        ccDown.delegate = self
        ccPlus.delegate = self
        ccMinus.delegate = self
        
        ccUp.changeShapeToSquare()
        ccDown.changeShapeToSquare()
        ccPlus.changeShapeToSquare()
        ccMinus.changeShapeToSquare()
        
        cc1.delegate = self
        cc2.delegate = self
        cc3.delegate = self
        cc4.delegate = self
        cc5.delegate = self
        
        cc1.changeShapeToSquare()
        cc2.changeShapeToSquare()
        cc3.changeShapeToSquare()
        cc4.changeShapeToSquare()
        cc5.changeShapeToSquare()
        
        rText.delegate = self
        gText.delegate = self
        bText.delegate = self
        hText.delegate = self
        sText.delegate = self
        vText.delegate = self

        hexText.delegate = self
        rgbText.delegate = self
        hslText.delegate = self

        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: "Picker", bundle: bundle)
        var topLevelObjects: NSArray?
        nib?.instantiate(withOwner: pickerWin, topLevelObjects: &topLevelObjects)
        if let found = topLevelObjects?.first(where: { $0 is Picker }) {
            picker = found as? Picker
            picker.parent = self
            picker.delegate = self
        }

        pickerWin = NSWindow(contentRect: NSRect(x: 0, y: 0, width: picker.pickerSize, height: picker.pickerSize), styleMask: .borderless, backing: .buffered, defer: true)
        
        pickerWin.backgroundColor = NSColor.clear
        pickerWin.level = convertToNSWindowLevel(Int(CGWindowLevelForKey(.maximumWindow)))
        pickerWin.contentView?.addSubview(picker)
        pickerWin.hasShadow = true
        pickerWin.invalidateShadow()

        hexText.window?.makeFirstResponder(nil)

        harmonyPressed(analogousHarmony)
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }

        setFromColor()
    }
    
    func setFromColor() {
        hFloat = color.hueComponent
        sFloat = color.saturationComponent
        vFloat = color.brightnessComponent
        rFloat = color.redComponent
        gFloat = color.greenComponent
        bFloat = color.blueComponent
        
        setSliders()
    }
    
    func clamp(_ value: CGFloat, max: CGFloat = 1, min: CGFloat = 0) -> CGFloat {
        if value.isNaN { return 0 }
        return value > 1 ? 1 : value < 0 ? 0 : value
    }
    
    func clampFloatTo (_ value: CGFloat, max: Int = 255, min: Int = 0) -> Int {
        return clampTo(Int(round(value)), max: max, min: min)
    }
    
    func clampTo (_ value: Int, max: Int = 255, min: Int = 0) -> Int {
        if (value < min) { return min; }
        if (value > max) { return max; }
        return value
    }
    
    func addHue(_ h: CGFloat, _ add: CGFloat) -> CGFloat {
        if modeButton.state.rawValue == 0 {
            return (360 + h + add).truncatingRemainder(dividingBy: 360)
        }
        
        let g = convertHueRGBtoRYB(h) + add
        return convertHueRYBtoRGB((360 + g).truncatingRemainder(dividingBy: 360))
    }
    
    // swiftlint:disable:next function_body_length
    func setSliders() {
        tipLabel.stringValue = "Click + on the color dial to add the current color to history swatches."

        if lockButton.state.rawValue == 0 && color != lockedColor {
            lockedColor = color
            defaults.setNSColor(color, forKey: "currentColor")
        }
        
        let rInt = clampTo(rValue)
        let gInt = clampTo(gValue)
        let bInt = clampTo(bValue)
        let hInt = clampTo(hValue, max: 359)
        let sInt = clampTo(sValue, max: 100)
        let vInt = clampTo(vValue, max: 100)
        
        rText.integerValue = rInt
        gText.integerValue = gInt
        bText.integerValue = bInt
        hText.integerValue = hInt
        sText.integerValue = sInt
        vText.integerValue = vInt

        rStepper.integerValue = rInt
        gStepper.integerValue = gInt
        bStepper.integerValue = bInt
        hStepper.integerValue = hInt
        sStepper.integerValue = sInt
        vStepper.integerValue = vInt

        rSlider.integerValue = rInt
        gSlider.integerValue = gInt
        bSlider.integerValue = bInt
        hSlider.integerValue = hInt
        sSlider.integerValue = sInt
        vSlider.integerValue = vInt
        
        colorWell.color = color
        
        rSliderCell.setColors(0, g1: gValue, b1: bValue, r2: 255, g2: gValue, b2: bValue)
        gSliderCell.setColors(rValue, g1: 0, b1: bValue, r2: rValue, g2: 255, b2: bValue)
        bSliderCell.setColors(rValue, g1: gValue, b1: 0, r2: rValue, g2: gValue, b2: 255)
        hSliderCell.setHue(sValue, v: vValue)
        sSliderCell.setSaturation(hValue, v: vValue)
        vSliderCell.setBrightness(hValue, s: sValue)
        
        rSlider.setNeedsDisplay()
        gSlider.setNeedsDisplay()
        bSlider.setNeedsDisplay()
        hSlider.setNeedsDisplay()
        sSlider.setNeedsDisplay()
        vSlider.setNeedsDisplay()
        
        if (editingTextType != "hexText") {
            hexText.stringValue = String(format: "#%02x%02x%02x", rInt, gInt, bInt)
        }
        
        if (editingTextType != "rgbText") {
            rgbText.stringValue = String(format: "rgb(%d, %d, %d)", rInt, gInt, bInt)
        }
        
        if (editingTextType != "hslText") {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var l: CGFloat = 0
            var a: CGFloat = 0
            color.get(&h, saturation: &s, lightness: &l, alpha: &a)
            
            if (l > 0.999) { ccUp.isHidden = true; } else if (ccUp.isHidden) { ccUp.isHidden = false; }
            
            if (l < 0.001) { ccDown.isHidden = true; } else if (ccDown.isHidden) { ccDown.isHidden = false; }

            if (s > 0.999) { ccPlus.isHidden = true; } else if (ccPlus.isHidden) { ccPlus.isHidden = false; }

            if (s < 0.001) { ccMinus.isHidden = true; } else if (ccMinus.isHidden) { ccMinus.isHidden = false; }
            
            hslText.stringValue = String(format: "hsl(%0.1f, %0.1f%%, %0.1f%%)", h*360, s*100, l*100)
        }

        let h = lockedColor.hueComponent * 360
        let s = lockedColor.saturationComponent * 100
        let v = lockedColor.brightnessComponent * 100

        cc0.setHSV(h, s: s, v: v)
        cc30.setHSV(addHue(h, 30), s: s, v: v)
        cc60.setHSV(addHue(h, 60), s: s, v: v)
        cc90.setHSV(addHue(h, 90), s: s, v: v)
        cc120.setHSV(addHue(h, 120), s: s, v: v)
        cc150.setHSV(addHue(h, 150), s: s, v: v)
        cc180.setHSV(addHue(h, 180), s: s, v: v)
        cc210.setHSV(addHue(h, 210), s: s, v: v)
        cc240.setHSV(addHue(h, 240), s: s, v: v)
        cc270.setHSV(addHue(h, 270), s: s, v: v)
        cc300.setHSV(addHue(h, 300), s: s, v: v)
        cc330.setHSV(addHue(h, 330), s: s, v: v)

        ccUp.lighten(lockedColor, n: 0.05)
        ccDown.lighten(lockedColor, n: -0.05)

        ccPlus.saturate(lockedColor, n: 0.05)
        ccMinus.saturate(lockedColor, n: -0.05)

//        ccUp.setHSV(h, s: s, v: v + 20)
//        ccDown.setHSV(h, s: s, v: v - 20)
//        ccPlus.setHSV(h, s: s + 20, v: v)
//        ccMinus.setHSV(h, s: s - 20, v: v)

        cc3.setHSV(h, s: s, v: v)
        
        switch (harmony) {
        case "analogous":
            cc1.setHSV(addHue(h, 30), s: addValueOverflowBounce(s, 5), v: addValueOverflowSlow(v, 5, min: 20))
            cc2.setHSV(addHue(h, 15), s: addValueOverflowBounce(s, 5), v: addValueOverflowFlip(v, 9, min: 20))
            cc4.setHSV(addHue(h, -15), s: addValueOverflowBounce(s, 5), v: addValueOverflowFlip(v, 9, min: 20))
            cc5.setHSV(addHue(h, -30), s: addValueOverflowBounce(s, 5), v: addValueOverflowSlow(v, 5, min: 20))
            break
        case "complementary":
            cc1.setHSV(addHue(h, 0), s: addValueOverflowSlow(s, 10), v: addValueOverflowFlip(v, -30, lcap: 20))
            cc2.setHSV(addHue(h, 0), s: addValueOverflowCap(s, -10), v: addValueOverflowCap(v, 30))
            cc4.setHSV(addHue(h, 180), s: addValueOverflowCap(s, 20), v: addValueOverflowFlip(v, -30, lcap: 20))
            cc5.setHSV(addHue(h, 180), s: s, v: v)
            break
        case "compound":
            cc1.setHSV(addHue(h, 30), s: addValueOverflowFlip(s, 10), v: addValueOverflowFlip(v, 20))
            cc2.setHSV(addHue(h, 30), s: addValueOverflowFlip(s, -40), v: addValueOverflowFlip(v, 40))
            cc4.setHSV(addHue(h, 165), s: addValueOverflowFlip(s, -25), v: addValueOverflowSlow(v, 5, brake: 40))
            cc5.setHSV(addHue(h, 150), s: addValueOverflowFlip(s, 10), v: addValueOverflowCap(v, 20))
            break
        case "monochromatic":
            cc1.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), v: addValueOverflowFlip(v, 30))
            cc2.setHSV(addHue(h, 0), s: addValueOverflowFlip(s, -30), v: addValueOverflowSlow(v, 10, brake: 50))
            cc4.setHSV(addHue(h, 0), s: addValueOverflowFlip(s, -30), v: addValueOverflowFlip(v, 30))
            cc5.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), v: addValueOverflowOppose(v, 60, roffs: 20))
            break
        case "shades":
            cc1.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), v: addValueOverflowFlip(v, -25, lcap: 20))
            cc2.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), v: addValueOverflowFlip(v, -50, lcap: 20))
            cc4.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), v: addValueOverflowFlip(v, -75))
            cc5.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), v: addValueOverflowSlow(v, -10, brake: 15))
            break
        case "triadic":
            cc1.setHSV(addHue(h, 0), s: addValueOverflowFlip(s, 10), v: addValueOverflowFlip(v, -30, lcap: 20))
            cc2.setHSV(addHue(h, 120), s: addValueOverflowFlip(s, -10), v: addValueOverflowSlow(v, 5, min: 20, brake: 30))
            cc4.setHSV(addHue(h, -120), s: addValueOverflowFlip(s, 10), v: addValueOverflowFlip(v, -20, lcap: 20))
            cc5.setHSV(addHue(h, -120), s: addValueOverflowFlip(s, 5), v: addValueOverflowFlip(v, 30))
            break
        default: break
        }
        
        textBgColor = hexText.backgroundColor
    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertToNSControlStateValue(_ input: Int) -> NSControl.StateValue {
	return NSControl.StateValue(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToNSWindowLevel(_ input: Int) -> NSWindow.Level {
	return NSWindow.Level(rawValue: input)
}
