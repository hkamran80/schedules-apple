//
//  ContentView.swift
//  Shared
//
//  Created by H. Kamran on 2/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var schedules: [Schedule] = []

    var body: some View {
        NavigationView {
            if !schedules.isEmpty {
                List(schedules.sorted { $0.id.lowercased() < $1.id.lowercased() }, id: \.self) { schedule in
                    NavigationLink(destination: ScheduleView(schedule: schedule)) {
                        Text(schedule.name)
                    }
                }
                .listStyle(DefaultListStyle())
                .navigationTitle("Schedules")
            } else {
                Text("No schedules found")
                    .navigationTitle("Schedules")
            }
        }
        .onAppear(perform: {
            if let filePath = Bundle.main.path(forResource: "schedules", ofType: "json") {
                do {
                    let string = try String(contentsOfFile: filePath)
                    schedules = importSchedule(scheduleData: Data(string.utf8))
                } catch {
                    print("(Schedules Loading) \(error.localizedDescription)")
                }
            } else {
                print("No bundled file")
            }
        })
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
