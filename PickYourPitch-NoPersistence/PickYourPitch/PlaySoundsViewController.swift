//
//  PlaySoundsViewController.swift
//  Pick Your Pitch
//
//  Created by Udacity on 1/5/15.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

// MARK: - PlaySoundsViewController: UIViewController

class PlaySoundsViewController: UIViewController {

    // MARK: Properties

    static let SliderValueKey = "PitchValue"
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var sliderViewCancellable: AnyCancellable?
    
    // MARK: Outlets
    
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        } catch _ {
            audioPlayer = nil
        }
        audioPlayer.enableRate = true

        audioEngine = AVAudioEngine()
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        } catch _ {
            audioFile = nil
        }
        
        setUserInterfaceToPlayMode(false)

        // TODO initialize sliderView.value from user defaults here
        sliderView.value = UserDefaults.standard.float(forKey: Self.SliderValueKey)
//        sliderViewCancellable = sliderView.publisher(for: \.value)
//            .sink {
//                UserDefaults.standard.set($0, forKey: Self.SliderValueKey)
//                print("Updated \(Self.SliderValueKey) to \($0)")
//            }
//        sliderViewCancellable = sliderView.publisher(for: UIControl.Event.valueChanged)
//            .sink {
//                UserDefaults.standard.set($0, forKey: Self.SliderValueKey)
//                print("Updated \(Self.SliderValueKey) to \($0)")
//            }

    }
    
    // MARK: Set Interface
    
    func setUserInterfaceToPlayMode(_ isPlayMode: Bool) {
        startButton.isHidden = isPlayMode
        stopButton.isHidden = !isPlayMode
        sliderView.isEnabled = !isPlayMode
    }

    // MARK: Actions
    
    @IBAction func playAudio(_ sender: UIButton) {
        
        // Get the pitch from the slider
        let pitch = sliderView.value
        print("My Read Pitch: \(pitch)")
        
        // Play the sound
        playAudioWithVariablePitch(pitch)
        
        // Set the UI
        setUserInterfaceToPlayMode(true)
        
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func sliderDidMove(_ sender: UISlider) {
        print("[MOVE] Slider value: \(sliderView.value)")
    }
    
    // MARK: Play Audio
    
    func playAudioWithVariablePitch(_ pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            // When the audio completes, set the user interface on the main thread
            DispatchQueue.main.async {self.setUserInterfaceToPlayMode(false) }
        }
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
}
