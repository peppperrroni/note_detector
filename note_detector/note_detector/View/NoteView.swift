//
//  ContentView.swift
//  note_detector
//
//  Created by Yuriy Egorov on 11/8/24.
//

import SwiftUI

struct NoteView: View {
    struct Style {
        let font: Font
        
        public init(font: Font) {
            self.font = font
        }
    }
    
    let title: String
    let style: Style

    
    var body: some View {
        VStack {
            Text(self.title)
                .font(self.style.font)
        }
        .padding()
    }
}

#Preview { NoteView(title: "A", style: .init(font: .body))}
