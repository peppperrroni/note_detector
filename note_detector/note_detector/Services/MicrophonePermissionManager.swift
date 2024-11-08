//
//  MicrophonePermissionManager.swift
//  note_detector
//
//  Created by Yuriy Egorov on 11/8/24.
//

import Foundation
import AVFAudio

enum PermissionStatus {
    case granted, denied, undetermined
}

protocol PermissionManagerProtocol {
    var microphonePermissionStatus: PermissionStatus { get }
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) async
}

final class PermissionManager: PermissionManagerProtocol {
    var microphonePermissionStatus: PermissionStatus
    
    init() {
        self.microphonePermissionStatus = {
            switch AVAudioApplication.shared.recordPermission {
            case .denied:
                    .denied
            case .granted:
                    .granted
            case .undetermined:
                    .undetermined
            @unknown default:
                    .undetermined
            }
        }()
    }
    
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) async {
         AVAudioApplication.requestRecordPermission(completionHandler: completion)
    }
}
