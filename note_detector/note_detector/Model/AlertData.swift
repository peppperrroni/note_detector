//
//  AlertData.swift
//  note_detector
//
//  Created by Yuriy Egorov on 12/30/24.
//

public struct AlertData {
    let title: String
    let subtitle: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let primaryButtonAction: (() -> Void)?
    let secondaryButtonAction: (() -> Void)?
    var isPresented: Bool
}
