//
//  NoteDetectorViewModel.swift
//  note_detector
//
//  Created by Yuriy Egorov on 11/8/24.
//

import Foundation
import UIKit

protocol NoteDetectorViewModelProtocol : ObservableObject {
    var frequency: Int { get }
    func startDetecting() async
}

final class NoteDetectorViewModel: NoteDetectorViewModelProtocol {
    private let permissionManager: PermissionManagerProtocol
    
    @Published var frequency: Int = 0
    
    init(permissionManager: PermissionManagerProtocol) {
        self.permissionManager = permissionManager
    }
    
    @MainActor
    func startDetecting() async {
        switch permissionManager.microphonePermissionStatus {
        case .granted:
            self.startFetchingMicrophoneInput()
        case .denied:
            self.openAppSettings()
        case .undetermined:
            await self.permissionManager.requestMicrophonePermission { result in
                result ? self.startFetchingMicrophoneInput() : print("Permission wasn't permitted")
            }
        }
    }
    
    private func startFetchingMicrophoneInput() {
        self.frequency = 440
    }
    
    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
}
