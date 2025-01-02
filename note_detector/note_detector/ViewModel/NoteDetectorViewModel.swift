//
//  NoteDetectorViewModel.swift
//  note_detector
//
//  Created by Yuriy Egorov on 11/8/24.
//

import UIKit
import Combine

protocol NoteDetectorViewModelProtocol : ObservableObject {
    var frequency: Double { get }
    var alertData: AlertData { get }
    func startDetecting() async
}

final class NoteDetectorViewModel: NoteDetectorViewModelProtocol {
    private let permissionManager: PermissionManagerProtocol
    private let frequencyDetector: FrequencyDetectorServiceProtocol
    
    @Published var frequency: Double = 0
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
    
    private var observables: Set<AnyCancellable> = []
    
    init(
        permissionManager: PermissionManagerProtocol = PermissionManager(),
        frequencyDetector: FrequencyDetectorServiceProtocol = FrequencyDetectorService()
    ) {
        self.permissionManager = permissionManager
        self.frequencyDetector = frequencyDetector
        frequencyDetector
            .frequencyPublisher()
            .sink { [weak self] newValue in
                self?.frequency = newValue
            }
            .store(
                in: &self.observables
            )
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
        self.frequencyDetector.start()
    }
}
