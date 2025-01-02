//
//  Note.swift
//  note_detector
//
//  Created by Yuriy Egorov on 12/30/24.
//
import Foundation

public enum Note: String, CaseIterable {
    case C
    case CSharp = "C#"
    case D
    case DSharp = "D#"
    case E
    case F
    case FSharp = "F#"
    case G
    case GSharp = "G#"
    case A
    case ASharp = "A#"
    case B
    case CFlat = "Cb"
    case DFlat = "Db"
    case EFlat = "Eb"
    case GFlat = "Gb"
    case AFlat = "Ab"
    case BFlat = "Bb"
    
    static let referenceFrequencies: [Note: Double] = [
        .C: 261.63, .CSharp: 277.18, .D: 293.66, .DSharp: 311.13,
        .E: 329.63, .F: 349.23, .FSharp: 369.99, .G: 392.00,
        .GSharp: 415.30, .A: 440.00, .ASharp: 466.16, .B: 493.88
    ]
    
    public static func frequency(for note: Note, octave: Int) -> Double {
        // Frequency of the note in the 4th octave
        let referenceFrequency = referenceFrequencies[note] ?? 0.0
        
        // Calculate the number of semitones from A4
        let semitoneRatio = pow(2.0, 1.0 / 12.0)
        let semitonesFromA4 = Double(octave - 4) * 12.0  // Octave difference from 4th octave
        
        // Calculate the final frequency
        let frequency = referenceFrequency * pow(semitoneRatio, semitonesFromA4)
        
        return frequency
    }
    
    public static func fromFrequency(_ frequency: Double) -> Note? {
        // Constants
        let a4Frequency = 440.0
        let semitoneRatio = pow(2.0, 1.0 / 12.0) // Ratio between semitones
        
        // Calculate the number of semitones from A4
        let semitonesFromA4 = round(12 * log2(frequency / a4Frequency))
        let noteIndex = Int(semitonesFromA4).mod(Note.allCases.count)
        
        // Map index to note
        return Note.allCases[noteIndex]
    }
    
    public static func octaveForFrequency(_ frequency: Double) -> Int {
        let a4Frequency = 440.0
        let semitoneRatio = pow(2.0, 1.0 / 12.0)
        
        // Calculate the number of semitones from A4
        let semitonesFromA4 = round(12 * log2(frequency / a4Frequency))
        
        // Octave is based on the formula: octave = floor(semitonesFromA4 / 12)
        let octave = Int(semitonesFromA4) / 12
        
        return octave
    }
}
