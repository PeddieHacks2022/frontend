//
//  WorkoutController.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-20.
//

import Foundation
import AVKit
class WorkoutController{
    var audioPlayer: AVAudioPlayer!
    let dingSound = Bundle.main.path(forResource: "ding-sound-effect_2", ofType: "mp3")
    let synthesizer = AVSpeechSynthesizer()
    var reps = 0
    var workouts: [WorkoutTemplate] = []
    var counter = 0
    
    func initialize(workouts: [WorkoutTemplate]){
        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: dingSound!))
        self.workouts = workouts
    }
    func update(){
        if counter%10==0{
            Task{
                var data = await construct.pollReps()
                if data["change"] == nil{
                    return
                }
                var change = data["change"] as! String
                if change == "up"{
                    
                    reps+=1
                    audioPlayer.play()
                }else if change == "down"{
                    
                }else if change == "bad form"{
                    speak(sentence:data["details"] as! String)
                }
            }
            
        }
        counter+=1
    }
    func speak(sentence: String){
        let utterance = AVSpeechUtterance(string: sentence)
        synthesizer.speak(utterance)
        
        
    }
    
    
    
}
var controller = WorkoutController()
