//
//  WorkoutController.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-20.
//

import AVKit
import Foundation
class WorkoutController {
    var audioPlayer: AVAudioPlayer!
    let dingSound = Bundle.main.path(forResource: "ding-sound-effect_2", ofType: "mp3")
    let synthesizer = AVSpeechSynthesizer()
    var reps = 0
    var counter = 0
    var complete = false

    func initialize() {
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: dingSound!))
    }

    func update() {
        if counter % 10 == 0 {
            Task {
                var data = await construct.pollReps()
                if data["change"] == nil {
                    return
                }

                var change = data["change"] as! String

                if change == "up" {
                    reps += 1
                    speak(sentence: String(reps))
                } else if change == "down" {
                } else if change == "bad form" {
                    speak(sentence: data["details"] as! String)
                } else if change == "complete" {
                    speak(sentence: "Completed")
                    complete = true
                }
            }
        }
        counter += 1
    }

    func speak(sentence: String) {
        let utterance = AVSpeechUtterance(string: sentence)
        synthesizer.speak(utterance)
    }
}

var controller = WorkoutController()
