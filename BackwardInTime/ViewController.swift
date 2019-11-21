//
//  ViewController.swift
//  BackwardInTime
//
//  Created by Curtis Bellamy on 2019-11-18.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import NotificationView

class ViewController: UIViewController {
    
    @IBOutlet weak var timeReadout: UILabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var timer = Timer()
    var currentDate = Date()
        
    var duration : Int = 60
    var seconds : Int = 0
    var minutes : Int = 0
    var hours : Int = 0
    var progressIncrement : Float = 0.0
    
    var obj = HistoricData()

    var percentages = [Double]()
    var intervals = [Double]()
    
    var percentage : Double = 0.0
    var info : String = ""
    var matchedDate : String = ""
    
    var keys = [String]()
    
    
    var data = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 20)
        

        data = obj.events

        
        timePicker.addTarget(self, action: #selector(timePickerChanged(picker:)), for: .valueChanged)
        
        let calendar = Calendar(identifier: .gregorian)
        let date = DateComponents(calendar: calendar, hour: 0, minute: 1).date!
        timePicker.setDate(date, animated: true)
        
        timeReadout.text = "00:00:00"
        progressBar.progress = 0.0
        calcIncrement()
        
        
        //let e = Darwin.M_E



    
        calcPercentages()
        calcIntervals()
        
        for item in data {
            keys.append(item.date)
        }
                    
    
        
        
        
    }
    
    private func clearPresets() {
        percentages.removeAll()
        intervals.removeAll()
    }
    
    
    private func calcIntervals(){
        for value in percentages {
            let interval = abs( Double(duration) - ((value/100) * Double(duration)) )
            intervals.append(interval)
        }
        
//        for item in data {
//            print(item)
//        }
//
        for item in intervals {
            print(item)
        }
//
//        for item in percentages {
//            print(item)
//        }
    
    }
    
    
    private func calcPercentages() {
        var percentage : Double = 0.0
        for item in data {
            
            if item.date.contains("years ago") {
                
                var numericValue = Double(item.date.components(separatedBy: CharacterSet.init(charactersIn: "0123456789.").inverted).joined(separator: ""))
                
                if item.date.contains("million"){
                    numericValue! *= 1000000
                    
                } else if item.date.contains("billion"){
                    numericValue! *= 1000000000
                }

                percentage = pow((( log(numericValue! + exp(3)) - 3) / 20.3444), (1/3)) * 100
                
                var truncated = Double(floor(100*percentage)/100)

                percentages.append(truncated)
                
            } else {
                
                let calendar = Calendar(identifier: .gregorian)

                
                let tempDate = Date(item.date)
                
                
                let components = calendar.dateComponents([.day], from: tempDate, to: currentDate)
                let percentage = pow(( ( log( Double(components.day!) / 365.242199 + exp(3)  ) - 3 ) / 20.3444 ), (1/3)) * 100
                
                var truncated = Double(floor(100*percentage)/100)

                percentages.append(truncated)
                
            }
        }
        
        percentages.sort()
        
    
        
    }
    
    
    private func resetTimer() {
        timer.invalidate()
        hours = 0
        minutes = 0
        seconds = 0
        duration = 60
        timeReadout.text = "00:00:00"
        progressBar.progress = 0.0
    }
    
    private func calcIncrement() {
        progressIncrement = 1.0 / Float(duration)
    }
    
    
    @IBAction func startClicked(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopClicked(_ sender: Any) {
        resetTimer()
     
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EventViewController
            vc.dateText = "\(matchedDate)"
            vc.percentageText = "\(percentage)%"
            vc.infoText = "\(info)"
        
    }
    
    
    @objc func counter() {
        var count : Int = 0;
        
        let state = UIApplication.shared.applicationState

        
        if duration >= 0 {
            
            for item in intervals {
                if(duration == Int(item)){
                    
                    percentage = percentages[count]
                    info = data[count].info
                    matchedDate = keys[count]
                    
                        
                    performSegue(withIdentifier: "showModal", sender: nil)

                    
            
                }
                count += 1

            }

            hours = duration / 3600
            minutes = duration / 60 % 60
            seconds = duration % 60
            timeReadout.text = ((hours<10) ? "0" : "") + String(hours) + ":" + ((minutes<10) ? "0" : "") + String(minutes) + ":" + ((seconds<10) ? "0" : "") + String(seconds)
            
            
            duration -= 1
            
            progressBar.progress += progressIncrement

        }
        
        count = 0
        
        
    }

    
    @objc func timePickerChanged(picker: UIDatePicker) {
        clearPresets()
        duration = Int(picker.countDownDuration)
        calcPercentages()
        calcIntervals()
        calcIncrement()
    }
    

}

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}
