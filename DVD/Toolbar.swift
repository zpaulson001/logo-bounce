//
//  DVDApp.swift
//  DVD
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

@main
struct DVDApp: App {
    var body: some Scene {
        @State var isShowingPopover = false
        WindowGroup {
            ContentView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button (action: {
                            isShowingPopover = true
                        }) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .popover(isPresented: $isShowingPopover) {
                            Text("yo")
                        }
                    }
                }
                .navigationTitle("")
            
        }
    }
}

