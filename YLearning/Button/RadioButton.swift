//
//  RadioButton.swift
//  YLearning
//
//  Created by PADDY on 2024/4/22.
//

import Foundation
import SwiftUI

struct RadioOption: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 10) {
                Text(text)
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
            }
        }
        .foregroundColor(.primary)
    }
}
