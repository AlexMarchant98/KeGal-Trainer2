//
//  SoundBite.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 22/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import AVFoundation

class SoundBite {
    
    let _userPreferences = UserDefaults.standard
    var _audioPlayer = AVAudioPlayer()
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    
    func playBeginSoundBite() {
        if(_userPreferences.bool(forKey: "SoundMuted") == false)
        {
            do {
                self._audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Begin", ofType: "wav")!))
                self._audioPlayer.play()
            }
            catch {
                print(error)
            }
        }
    }
    
    func playRestSoundBite() {
        if(_userPreferences.bool(forKey: "SoundMuted") == false)
        {
            do {
                self._audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Rest", ofType: "wav")!))
                self._audioPlayer.play()
            }
            catch {
                print(error)
            }
        }
    }
    
    func playWorkoutCompleteSoundBite() {
        if(_userPreferences.bool(forKey: "SoundMuted") == false)
        {
            do {
                self._audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Workout Complete", ofType: "wav")!))
                self._audioPlayer.play()
            }
            catch {
                print(error)
            }
        }
    }
}
