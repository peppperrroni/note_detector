//
//  NoteDetectorService.swift
//  note_detector
//
//  Created by Yuriy Egorov on 12/30/24.
//

import Foundation
import Combine

public protocol FrequencyDetectorServiceProtocol {
    func start()
    func stop()
    func frequencyPublisher() -> AnyPublisher<Double, Never>
}

final class FrequencyDetectorService: FrequencyDetectorServiceProtocol {
    private var frequencySubject = PassthroughSubject<Double, Never>()
    private(set) var frequency: Double = 440.0 {
        didSet {
            frequencySubject.send(frequency)
        }
    }
    
    func start() {
        frequency = 220.0
    }
    
    func stop() {
        frequency = 440.0
    }
    
    func frequencyPublisher() -> AnyPublisher<Double, Never> {
        return frequencySubject.eraseToAnyPublisher()
    }
}
