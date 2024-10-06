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
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var jerryGif: UIImageView!
    
    
    @IBOutlet var jerryImageViews: [UIImageView]!
    
    var score = 0
    var timer = Timer()
    var counter = 0
    var jerryArray = [UIImageView]()
    var hideTimer = Timer()
    var highScore = 0
    
    // Constants
    let gameDuration = 10
    let jerryHideInterval = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoGif = UIImage.gifImageWithName("jerryGif")
        jerryGif.image = logoGif
        
        scoreLabel.text = "\(score)"
        button.dropShadow(radius: 1.0)
        
        checkHighScore()
        setupJerryImageViews()
    }
    
    // Highscore check
    func checkHighScore() {
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        if let newScore = storedHighScore as? Int {
            highScore = newScore
        } else {
            highScore = 0
        }
        highScoreLabel.text = "\(highScore)"
    }
    
    // Arranging jerry pics
    func setupJerryImageViews() {
        for jerry in jerryImageViews {
            jerry.isUserInteractionEnabled = true
            jerry.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(increaseScore)))
        }
        jerryArray = jerryImageViews
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        startGame()
    }
    
    func startGame() {
        jerryGif.isHidden = true
        score = 0
        scoreLabel.text = "\(score)"
        counter = gameDuration
        timeLabel.text = String(counter)
        
        // start timers
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: jerryHideInterval, target: self, selector: #selector(hideJerry), userInfo: nil, repeats: true)
        
        hideJerry()
        button.isHidden = true
    }
    
    @objc func hideJerry() {
        for jerry in jerryArray {
            jerry.isHidden = true
        }
        
        // show a random jerry
        let random = Int(arc4random_uniform(UInt32(jerryArray.count)))
        jerryArray[random].isHidden = false
    }
    
    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    @objc func countDown() {
        counter -= 1
        timeLabel.text = String(counter)
        
        if counter == 0 {
            endGame()
        }
    }
    
    func endGame() {
        timer.invalidate()
        hideTimer.invalidate()
        
        for jerry in jerryArray {
            jerry.isHidden = true
        }
        
        if score > highScore {
            highScore = score
            highScoreLabel.text = "\(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highscore")
        }
        
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Time's Up", message: "One more?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            self.button.isHidden = false
            self.jerryGif.isHidden = false
        }
        let replayButton = UIAlertAction(title: "Replay", style: .default) { _ in
            self.startGame()
        }
        alert.addAction(okButton)
        alert.addAction(replayButton)
        present(alert, animated: true, completion: nil)
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
