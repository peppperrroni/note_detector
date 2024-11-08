//
//  NoteDetectorView.swift
//  note_detector
//
//  Created by Yuriy Egorov on 11/8/24.
//

import SwiftUI

struct NoteDetectorView<ViewModel> : View where ViewModel: NoteDetectorViewModel {
    
    struct Style {
        let noteViewStyle: NoteView.Style
        
        init(noteViewStyle: NoteView.Style) {
            self.noteViewStyle = noteViewStyle
        }
    }
    
    @ObservedObject private var viewModel: ViewModel
    private let style: Style
    
    init(
        viewModel: ViewModel,
        style: Style
    ) {
        self.viewModel = viewModel
        self.style = style
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            NoteView(
                title: self.viewModel.frequency.description,
                style: self.style.noteViewStyle
            )
        }.onAppear {
            Task {
                await self.viewModel.startDetecting()
            }
        }
        .padding()
    }
}

#Preview {
    NoteDetectorView(
        viewModel: NoteDetectorViewModel(permissionManager: PermissionManager()),
        style: .init(noteViewStyle: .init(font: .body))
    )
}
