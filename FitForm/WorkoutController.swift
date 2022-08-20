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
    var prevReps = 0
    var workouts: [WorkoutTemplate] = []
    
    func initialize(workouts: [WorkoutTemplate]){
        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: dingSound!))
        self.workouts = workouts
    }
    func update(){
        if construct.reps != prevReps{
            prevReps = construct.reps
            audioPlayer.play()
        }
        
    }
    func speak(){
        let utterance = AVSpeechUtterance(string: "Hello world")
        
    }
    
    
    
}
var controller = WorkoutController()
