//
//  ListStyleModifier.swift
//  Schedules (iOS)
//
//  Created by H. Kamran on 4/28/21.
//

import SwiftUI

struct ListStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listStyle(SidebarListStyle())
    }
}

