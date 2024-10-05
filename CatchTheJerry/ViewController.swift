//
//  ViewController.swift
//  CatchTheJerry
//
//  Created by can on 4.10.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var jerry1: UIImageView!
    @IBOutlet weak var jerry2: UIImageView!
    @IBOutlet weak var jerry3: UIImageView!
    @IBOutlet weak var jerry4: UIImageView!
    @IBOutlet weak var jerry5: UIImageView!
    @IBOutlet weak var jerry6: UIImageView!
    @IBOutlet weak var jerry7: UIImageView!
    @IBOutlet weak var jerry8: UIImageView!
    @IBOutlet weak var jerry9: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    
    var score = 0
    var timer = Timer()
    var counter = 0
    var jerryArray = [UIImageView]()
    var hideTimer = Timer()
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(score)"
        button.dropShadow(radius: 1.0)
        
        
        //Highscore check
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "\(highScore)"
        }
        
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highScoreLabel.text = "\(highScore)"
        }
        
        
        //Images
        jerry1.isUserInteractionEnabled = true
        jerry2.isUserInteractionEnabled = true
        jerry3.isUserInteractionEnabled = true
        jerry4.isUserInteractionEnabled = true
        jerry5.isUserInteractionEnabled = true
        jerry6.isUserInteractionEnabled = true
        jerry7.isUserInteractionEnabled = true
        jerry8.isUserInteractionEnabled = true
        jerry9.isUserInteractionEnabled = true
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        jerry1.addGestureRecognizer(recognizer1)
        jerry2.addGestureRecognizer(recognizer2)
        jerry3.addGestureRecognizer(recognizer3)
        jerry4.addGestureRecognizer(recognizer4)
        jerry5.addGestureRecognizer(recognizer5)
        jerry6.addGestureRecognizer(recognizer6)
        jerry7.addGestureRecognizer(recognizer7)
        jerry8.addGestureRecognizer(recognizer8)
        jerry9.addGestureRecognizer(recognizer9)
        
        jerryArray = [jerry1, jerry2, jerry3, jerry4, jerry5, jerry6, jerry7, jerry8, jerry9]
        
        //Timers
        

        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        counter = 10
        timeLabel.text = String(counter)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hidejerry), userInfo: nil, repeats: true)
        
        hidejerry()
        button.isHidden = true
    }
    
    @objc func hidejerry() {
        
        for jerry in jerryArray {
            jerry.isHidden = true
        }
        
        let random = Int(arc4random_uniform(UInt32(jerryArray.count - 1)))
        jerryArray[random].isHidden = false
        
    }
    
    
    
    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func countDown() {
        
        counter -= 1
        timeLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            
            for jerry in jerryArray {
                jerry.isHidden = true
            }
            
            //HighScore
            
            if self.score > self.highScore {
                self.highScore = self.score
                highScoreLabel.text = "\(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highscore")
            }
            
            
            //Alert
            
            let alert = UIAlertController(title: "Time's Up", message: "One more?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.button.isHidden = false
            }
            
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
                //replay function
                
                self.score = 0
                self.scoreLabel.text = "\(self.score)"
                self.counter = 10
                self.timeLabel.text = String(self.counter)
                
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hidejerry), userInfo: nil, repeats: true)
            }
            
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
    }


}



extension UIView {
    func dropShadow(scale: Bool = true, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 5.0
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        layer.cornerRadius = 10
    }
}
