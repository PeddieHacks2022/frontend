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
        if counter%5==0{
            Task{
                var data = await construct.pollReps()
                var change = data["change"] as! String
                if change != "nothing"{
                    
                    reps+=1
                    audioPlayer.play()
                }
            }
            
        }
        counter+=1
    }
    func speak(){
        let utterance = AVSpeechUtterance(string: "Hello world")
        
    }
    
    
    
}
var controller = WorkoutController()
