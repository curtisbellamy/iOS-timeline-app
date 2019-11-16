//
//  ViewController.swift
//
//
//  Created by Curtis Bellamy on 11/12/19.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var picker: UIDatePicker!
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var timer = Timer()
    
    var inProgress: Bool = false;

    
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



    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        print(picker.countDownDuration)
        self.seconds = Int(picker.countDownDuration)
    }
    
    
    @IBAction func stopClicked(_ sender: Any) {
        setupCircleLayers()
        timer.invalidate()
        setupPercentageLabel()
        percentageLabel.text = "Start"
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
            inProgress = false;
        }
        
        self.percentageLabel.text = String(seconds)
        
    }
    
    fileprivate func animateCircle() {
        inProgress = true
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.seconds = Int(picker.countDownDuration)
        print(seconds)
    }

}
















