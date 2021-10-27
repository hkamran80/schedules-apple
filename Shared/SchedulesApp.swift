//
//  SchedulesApp.swift
//  Shared
//
//  Created by H. Kamran on 2/5/21.
//

import SwiftUI

@main
struct SchedulesApp: App {
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            ContentView()
                .frame(minWidth: 450, idealWidth: 500, maxWidth: .infinity, minHeight: 250, idealHeight: 250, maxHeight: 500, alignment: .center)
#elseif os(iOS)
//            ContentView()
#endif
        }
    }
}
