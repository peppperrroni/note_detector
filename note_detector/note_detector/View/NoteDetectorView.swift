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
            self.viewModel.startDetecting()
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.viewModel.startDetecting()
        }
        .alert(
            self.viewModel.alertData.title,
            isPresented: self.$viewModel.alertData.isPresented
        ) {
            alertButton(
                action: self.viewModel.alertData.primaryButtonAction,
                label: self.viewModel.alertData.primaryButtonTitle
            )
            alertButton(
                action: self.viewModel.alertData.secondaryButtonAction,
                label: self.viewModel.alertData.secondaryButtonTitle
            )
        } message: {
            Text(self.viewModel.alertData.subtitle)
        }
        .padding()
    }
    
    private func alertButton(action: (() -> Void)?, label: String) -> some View {
        if action == nil {
            return Button(label, role: .cancel) { }
        } else {
            return Button(label) { action?() }
        }
    }
}

#Preview {
    NoteDetectorView(
        viewModel: NoteDetectorViewModel(permissionManager: PermissionManager()),
        style: .init(noteViewStyle: .init(font: .body))
    )
}
