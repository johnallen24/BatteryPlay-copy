
//  Created by John Allen on 1/20/18.
//  Copyright © 2018 jallen.studios. All rights reserved.

// Controls the initial window

import UIKit
import Charts
import CoreBluetooth

class BatteryLevelController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    
    //MARK: Bluetooth Connection
    
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var LoPyPeripheral : CBPeripheral?
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Scan for peripherals if BLE is turned on
            central.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            // Can have different conditions for all states if needed - print generic message for now
            print("Bluetooth switched off or not initialized")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        let deviceName = "LoPy"
        let nameOfDeviceFound = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? String
        
        if (nameOfDeviceFound == deviceName) {
            print("SensorTag found")
            // Stop scanning
            LoPyPeripheral = peripheral
            self.centralManager.stopScan()
            // Set as the peripheral to use and establish connection
            
            self.LoPyPeripheral?.delegate = (self as CBPeripheralDelegate)
            print("hey")
        }
        else {
            print("SensorTag not found")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        isConnected = true
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if isConnected {
            let alertController = UIAlertController(title: "LoPy has Disconnected", message:
                "Make sure LoPy is turned on and running", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            changeToConnectButton()
            isConnected = false
        }
        
        LoPyPeripheral = nil
        centralManagerDidUpdateState(centralManager)
        
    }
    
    
    func changeToConnectButton() {
        connectButton.sizeToFit()
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitleColor(UIColor.blue, for: .normal)
    }
    
    func changeToDisconnectButton() {
        connectButton.setTitle("Disconnect", for: .normal)
        connectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        connectButton.setTitleColor(UIColor.red, for: .normal)
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("Looking at peripheral services")
        for service in peripheral.services! {
            print(service)
            
            if service.uuid == CBUUID(string: "36353433-3231-3039-3837-363534333231") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("Getting Voltages")
        for charateristic in service.characteristics! {
            
            let thisCharacteristic = charateristic as CBCharacteristic
            if (thisCharacteristic.uuid == CBUUID(string: "36353433-3231-3039-3837-363534336261"))
            {
                peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
        }
    }
    
    private var totalValues = 0.0
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if isConnected {
        if let stringValue = String(data: Data(characteristic.value!), encoding: .utf8)
        {
            totalValues += 1
            let doubleValue = Double(stringValue)!.rounded(toPlaces: 2)
            self.times.append(totalValues)
            self.sensorValues.append(doubleValue)
            
            
            self.updateGraph()
        }
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
    
    //* App does not actually disconnect when disconnect button is pressed. Only stops graphing*//
    
    
    private var isConnected = false // determines whether app is currently plotting the data
    
    @objc func connect(_ sender: UIButton) {
        
        // check to see if app is already connected
        if(connectButton.titleLabel?.text == "Disconnect")
        {
            isConnected = false
            changeToConnectButton()
        }
        else
        {
            // if LoPyPeripheral is not nil, the app has found the LoPy and can connect
            if let peripheral = LoPyPeripheral
            {
                changeToDisconnectButton()
                self.centralManager.connect(peripheral)
                
            }
            else
            {
                let alertController = UIAlertController(title: "Cannot Connect", message:
                    "Make sure LoPy is turned on and running", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    @objc func graphTapped() {
        print("touch touch")
        self.performSegue(withIdentifier: "toDataChart", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dataChartController = segue.destination as! dataChartController
        dataChartController.batteryLevels = self.sensorValues
        dataChartController.times = self.times
    }
    
    
    
    
    
    var times: [Double] = [] //holds time at every sensor value
    var sensorValues : [Double] = [] //holds all values from LoPy
   

    let portraitDisplayView: DisplayView = {
        let display = DisplayView()
        display.translatesAutoresizingMaskIntoConstraints = false
        return display
    }()
    
    let landscapeDisplayView: UIView = {
        let display = UIView()
        display.translatesAutoresizingMaskIntoConstraints = false
        return display
    }()
    
    let connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Voltage: "
        textView.font = UIFont.boldSystemFont(ofSize: 30)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let chtChart: LineChartView = {
        let view = LineChartView()
        view.noDataText = "Connect to sensor"
        view.noDataFont = NSUIFont(name: "HelveticaNeue", size: 18.0)
        let touchDown = UITapGestureRecognizer(target: self, action: #selector(graphTapped))
        view.addGestureRecognizer(touchDown)
        return view
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //******Graph Background Color******//
        chtChart.backgroundColor = colorWithHexString(hexString: "#FAF7F3")
        //*********************************//
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        view.addSubview(chtChart)
        setupPortraitLayout()
        
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            setupLandscapeFormat()
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            setupPortraitLayout()
        }
    }

    
    // when device is rotated, setup proper view layout
    @objc func deviceRotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            setupLandscapeFormat()
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            setupPortraitLayout()
        }
        
    }
    
    private func setupPortraitLayout() {
        
        landscapeDisplayView.removeFromSuperview()
        connectButton.removeFromSuperview()
        view.addSubview(portraitDisplayView)
        view.addSubview(connectButton)
        
        
        portraitDisplayView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        portraitDisplayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        portraitDisplayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        portraitDisplayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        connectButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        connectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        connectButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        // connectButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        connectButton.sizeToFit()
        
        connectButton.titleLabel?.adjustsFontSizeToFitWidth = true
        connectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        connectButton.addTarget(self, action: #selector(BatteryLevelController.connect(_:)), for: UIControlEvents.touchUpInside)
        
        chtChart.translatesAutoresizingMaskIntoConstraints = false
        chtChart.topAnchor.constraint(equalTo: portraitDisplayView.bottomAnchor, constant: 0).isActive = true
        chtChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        chtChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        chtChart.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        let touchDown = UITapGestureRecognizer(target: self, action: #selector(graphTapped))
        chtChart.addGestureRecognizer(touchDown)
    
    }
    
    
    private func setupLandscapeFormat() {
        portraitDisplayView.removeFromSuperview()
        connectButton.removeFromSuperview()
        view.addSubview(landscapeDisplayView)
        
        
        landscapeDisplayView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        landscapeDisplayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        landscapeDisplayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        landscapeDisplayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        
        landscapeDisplayView.addSubview(descriptionTextView)
        
        let sizeThatFitsTextView = descriptionTextView.sizeThatFits(CGSize(width: descriptionTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
        let heightOfText = sizeThatFitsTextView.height
        descriptionTextView.centerYAnchor.constraint(equalTo: landscapeDisplayView.centerYAnchor).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: heightOfText).isActive = true
        
        descriptionTextView.leadingAnchor.constraint(equalTo: landscapeDisplayView.leadingAnchor, constant: 0).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: landscapeDisplayView.trailingAnchor, constant: 0).isActive = true
        
        landscapeDisplayView.addSubview(connectButton)
        connectButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        connectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        connectButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        // connectButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        connectButton.sizeToFit()
        
        
        connectButton.titleLabel?.adjustsFontSizeToFitWidth = true
        connectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        connectButton.addTarget(self, action: #selector(BatteryLevelController.connect(_:)), for: UIControlEvents.touchUpInside)
        
        chtChart.topAnchor.constraint(equalTo: landscapeDisplayView.bottomAnchor, constant: 0).isActive = true
        chtChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        chtChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        chtChart.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        
    }
    
    @objc func update() {
    
    let number = arc4random_uniform(101) // [0, 100]
    
    totalValues += 1
    self.times.append(totalValues)
    self.sensorValues.append(Double(number))
    updateGraph()

    }
    
    func updateGraph(){
        
        portraitDisplayView.label.text = "\(sensorValues[sensorValues.count - 1])"
        descriptionTextView.text = "Current Voltage: \(sensorValues[sensorValues.count - 1])"
        
        var lineChartEntry  = [ChartDataEntry]()
        
        for i in 0..<times.count {
            
            let value = ChartDataEntry(x: times[i], y: sensorValues[i])
            
            lineChartEntry.append(value)
        }
        
        let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Voltage")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        chartDataSet.colors = [colorWithHexString(hexString: "#e8802f")]
        chartDataSet.setCircleColor(colorWithHexString(hexString: "#e8802f"))
        chartDataSet.circleHoleColor = colorWithHexString(hexString: "#e8802f")
        //#03C03C
        chartDataSet.circleHoleRadius = 0.15
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 2.5
        chartDataSet.mode = .cubicBezier
        
        
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.chartDescription?.enabled = true
        chtChart.legend.enabled = true
        chtChart.rightAxis.enabled = false
        chtChart.setVisibleXRange(minXRange: 0, maxXRange: 14)
        chtChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        chtChart.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        
        chtChart.leftAxis.drawGridLinesEnabled = true
        chtChart.leftAxis.drawLabelsEnabled = true
        
        chtChart.data = chartData
        
        
        if (times.count > 14)
        {
            //chtChart.moveViewToX(totalXmoved)
            chtChart.moveViewToAnimated(xValue: totalXmoved, yValue: 0, axis: YAxis.AxisDependency.left, duration: 1, easing: nil)
            
            totalXmoved += 1.0
        }
    }
    
    private var totalXmoved = 0.0
    
    
     func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
}




