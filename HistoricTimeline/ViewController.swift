//
//  ViewController.swift
//
//
//  Created by Curtis Bellamy on 11/12/19.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var picker: UIDatePicker!
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var timer = Timer()
    var inProgress: Bool = false;
    var obj = HistoricData()
    var data = [ Double : [String] ]()
    var keys = [Double]()
    var arr = [Double]()

    var seconds = 0
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        return layer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        view.backgroundColor = UIColor.backgroundColor
        
        setupCircleLayers()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setupPercentageLabel()
        
        let color1 = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) /* #ffffff */
        
        self.picker.setValue(color1, forKey: "textColor")
        
        seconds = Int(picker.countDownDuration)
        
        picker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        
        
        let calendar = Calendar(identifier: .gregorian)
        let date = DateComponents(calendar: calendar, hour: 0, minute: 1).date!
        picker.setDate(date, animated: true)
        
        data = obj.dictionary
                    

//        for (kind, numbers) in data {
//            print(kind)
//            for number in numbers {
//                print(number)
//            }
//        }
        for kind in data {
            keys.append(kind.key)
        }
        keys.sort()
        
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            
        }
        
        
        
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        
        
        let dateTrigger = Date().addingTimeInterval(10)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateTrigger)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            //check and handle errors
        }
        
    }
    
    func calcIntervals() -> [Double] {
        let duration = Double(picker.countDownDuration)
        
        var arr = [Double]()
        arr.append(0.073 * duration)
        arr.append(0.311 * duration)
        arr.append(0.4791 * duration)
        arr.append(0.7033 * duration)
        arr.append(0.9042 * duration)
        arr.append(1.0 * duration)
        
        for item in arr {
            print(item)
        }
        
//        let interval1 = 0.073 * duration
//        let interval2 = 0.311 * duration
//        let interval3 = 0.4791 * duration
//        let interval4 = 0.7033 * duration
//        let interval5 = 0.9042 * duration
//        let interval6 = 1.0 * duration
        
        return arr
    }
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        calcIntervals()
        print(picker.countDownDuration)
        self.seconds = Int(picker.countDownDuration)
    }
    
    
    @IBAction func stopClicked(_ sender: Any) {
        setupCircleLayers()
        timer.invalidate()
        setupPercentageLabel()
        percentageLabel.text = "Start"
        inProgress = false
        seconds = Int(picker.countDownDuration)
    }
    
    private func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        percentageLabel.center = view.center
    }
    
    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.2
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    

    
    @objc func counter() {
        
        seconds -= 1

        
        if seconds == 0 {
            print(data[keys[5]]!)
            setupCircleLayers()
            timer.invalidate()
            seconds = Int(picker.countDownDuration)
            inProgress = false;
            setupPercentageLabel()
            percentageLabel.text = "Start"
            return

        }
        
        let duration = Int(picker.countDownDuration)
        
        if seconds == duration - Int(arr[0]) {
            print(data[keys[0]]!)
        }
        
        if seconds == duration - Int(arr[1]) {
            print(data[keys[1]]!)
        }
        
        if seconds == duration - Int(arr[2]) {
            print(data[keys[2]]!)
        }
        
        if seconds == duration - Int(arr[3]) {
            print(data[keys[3]]!)
        }
        
        if seconds == duration - Int(arr[4]) {
            print(data[keys[4]]!)
        }
        
        if seconds == duration - Int(arr[5]) {
            print(data[keys[5]]!)
        }
            
//        if seconds == 55 || seconds == 50 {
//            performSegue(withIdentifier: "showModal", sender: nil)
//        }
        
    
        
        self.percentageLabel.text = String(seconds)
        
    }
    
    fileprivate func animateCircle() {
        inProgress = true
        
        arr = calcIntervals()
        
        self.percentageLabel.text = ""
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = picker.countDownDuration
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
    @objc private func handleTap() {
        
        
        if !inProgress {
            animateCircle()
        }
    }
    

}
















