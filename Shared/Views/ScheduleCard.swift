//
//  ScheduleCard.swift
//  Schedules
//
//  Created by H. Kamran on 4/27/21.
//

import SwiftUI

struct ScheduleCard: View {
    let header: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.subheadline)

            Text(content)
                .font(.largeTitle)
                .bold()
        }
        .padding(8)
    }
}

#if DEBUG
struct ScheduleCard_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleCard(header: "Period", content: "01:50:03")
    }
}
#endif
