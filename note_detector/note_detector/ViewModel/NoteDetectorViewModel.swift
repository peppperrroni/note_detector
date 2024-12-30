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
    var alertData: AlertData { get }
    func startDetecting() async
}

final class NoteDetectorViewModel: NoteDetectorViewModelProtocol {
    private let permissionManager: PermissionManagerProtocol
    
    @Published var frequency: Int = 0
    @Published var alertData: AlertData = AlertData(
        title: "Permission is not granted",
        subtitle: "Please grant access to microphone in settings to use the app",
        primaryButtonTitle: "Cancel",
        secondaryButtonTitle: "Go to settings",
        primaryButtonAction: { exit(0) },
        secondaryButtonAction: {
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        },
        isPresented: false
    )
    
    init(permissionManager: PermissionManagerProtocol = PermissionManager()) {
        self.permissionManager = permissionManager
    }
    
    func startDetecting() {
        switch permissionManager.microphonePermissionStatus {
        case .granted:
            self.startFetchingMicrophoneInput()
        case .denied:
            self.alertData.isPresented = true
        case .undetermined:
            self.permissionManager.requestMicrophonePermission { result in
                if result {
                    self.startFetchingMicrophoneInput()
                } else {
                    self.alertData.isPresented = true
                }
            }
        }
    }
    
    private func startFetchingMicrophoneInput() {
        self.alertData.isPresented = false
        self.frequency = 440
    }
}
