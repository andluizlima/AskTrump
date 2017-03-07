import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let answers = ["This is so important to me", "I mean, I don’t know if you’re gonna put this on television but you don’t even know what you’re talking about, try getting it out", "That is now what I wanna do for our country", "Super low energy, we need tremendous energy", "Tremendous potencial, it’s gonna be a beautiful thing", "It’s a little bit ridiculous thing", "No dream is too big, no challenge is too great", "You should be ashamed of yourself", "Nothing we want for our future is beyond our reach", "Not right now", "That’s OK", "You are going to approve one of the biggest tax increases in history", "It’s going to be a beautiful thing to watch", "All talk, no action, sounds good, doesn’t work, never gonna happen", "Republicans and democrats agree that this should be done", "No, you’re wrong", "Why not?", "This is one of the worst deals ever made by any country in history", "I tend to agree with that quite strongly", "It’s inappropriate, it’s not nice", "Well, I actually agree with that", "I think it’s disgraceful", "So good, specially when you have 20 trillion in debt", "It is a disastrous plan and it has to be repealed and replaced", "I believe that is very, very important", "It shouldn’t be allowed to happen", "I wouldn’t mind", "So ridiculous", "You would even be proud of it", "I’m shocked to hear that", "I think that it would be a great gesture", "Your decision making was absolutely terrible", "Hmmm, I like that", "You would be in jail", "Ting bing bong bong bing bing bing, you know what that is, right?", "I don’t care, I don’t care"]
    
    let first = ["Only Rosie O'Donnell", "Mexico is gonna pay for the wall", "I love China", "Tremendous energy", "The wall just got 10 feet taller", "You're really tough", "Do you have the stamina?"]

    @IBOutlet var background: UIImageView!
    @IBOutlet var answerField: UILabel!
    @IBOutlet var crowdButton: UIButton!
    
    @IBOutlet var trump: UIImageView!
    
    var line = AVAudioPlayer()
    var backgroundSound = AVAudioPlayer()
    
    var position = CGPoint(x: 100, y: 100)
    
    let im1 = UIImage(named: "Quiet.png")
    let im2 = UIImage(named: "Speaking.png")
    
    var recents: [Int] = []
    var crowd: Bool = true
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crowdButton.setImage(#imageLiteral(resourceName: "Loud"), for: UIControlState.normal)
        trump.image = im1
        answerField.text = first[Int(arc4random_uniform(UInt32(first.count)))]
        do{
            backgroundSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Crowd", ofType: "mp3")!))
            backgroundSound.prepareToPlay()
            backgroundSound.numberOfLoops = -1
            backgroundSound.play()
        } catch {
            print(error)
        }
        fillRecent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func newRand() -> Int{
        var new: Int = Int(arc4random_uniform(UInt32(answers.count)))
        var allowed: Bool = false
        while(!allowed){
            if(recents.contains(new)){
                new = Int(arc4random_uniform(UInt32(answers.count)))
            } else {
                for i in 0...(recents.count-2){
                    recents[i] = recents[i+1]
                }
                recents[recents.count-1] = new
                allowed = true
            }
        }
        return new
    }
    
    func fillRecent(){
        var allowed: Bool = false
        var new: Int = Int(arc4random_uniform(UInt32(answers.count)))
        for _ in 0...8{
            allowed = false
            while !allowed{
                if(recents.contains(new)){
                    new = Int(arc4random_uniform(UInt32(answers.count)))
                } else {
                    recents.append(new)
                    allowed = true
                }
            }
            
        }
    }
    
    func playSound(song: Int){
        do{
            line = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "\(song)", ofType: "mp3")!))
            line.prepareToPlay()
            line.play()
        } catch {
            print(error)
        }
    }
    
    func defineColor(answer: Int) -> UIColor{
        if(answer < 34){
            if(answer%2 == 0){
                return UIColor.blue
            } else {
                return UIColor.red
            }
        } else {
            return UIColor.yellow
        }
    }

    @IBAction func Ask(_ sender: Any) {
        let answer = newRand()
        answerField.textColor = defineColor(answer: answer)
        answerField.text = answers[answer]
        playSound(song: answer)
    }
    
    @IBAction func volumeButton(_ sender: Any) {
        if crowd{
            backgroundSound.stop()
            crowdButton.setImage(#imageLiteral(resourceName: "Mute"), for: UIControlState.normal)
            
        } else {
            backgroundSound.play()
            crowdButton.setImage(#imageLiteral(resourceName: "Loud"), for: UIControlState.normal)
        }
        crowd = !crowd
    }
}

