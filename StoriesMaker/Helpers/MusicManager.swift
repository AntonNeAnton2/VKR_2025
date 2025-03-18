//
//  MusicManager.swift
//  StoriesMaker
//
//  Created by borisenko on 04.02.2024.
//

import UIKit
import AVFoundation

class MusicManager {
    
    enum MusicFile: String {
        case mainTheme = "main-theme"
        case defaultStoryBackground = "default-story-background"
    }
    
    static let shared = MusicManager()
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.resume),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pause),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Private Properties
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: Public Methods
    func startMusic(_ musicFile: MusicFile, type: String = "m4a") {
        
        guard let bundle = Bundle.main.path(forResource: musicFile.rawValue, ofType: type) else { return }
        
        let musicUrl = NSURL(fileURLWithPath: bundle)
        
        let startPlaying = { [weak self] in
            guard let self else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: musicUrl as URL)
                
                guard let audioPlayer else { return }
                
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 0
                audioPlayer.play()
                audioPlayer.setVolume(1, fadeDuration: 1.0)
            } catch {
                print(error)
            }
        }
        
        if let audioPlayer {
            audioPlayer.setVolume(0, fadeDuration: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                startPlaying()
            })
        } else {
            startPlaying()
        }
    }
    
    @objc
    private func pause() {
        guard let audioPlayer else { return }
        audioPlayer.setVolume(0, fadeDuration: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            self?.audioPlayer?.pause()
        })
    }
    
    @objc
    private func resume() {
        guard let audioPlayer else { return }
        audioPlayer.play()
        audioPlayer.setVolume(1, fadeDuration: 1.0)
    }
}
