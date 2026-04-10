//
//  TimerInput.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/9/26.
//

import SwiftUI

struct TimerInput: View {
    var isFocused: FocusState<Bool>.Binding
    @State private var timerText: String = "0:00"
    @Environment(TimerManager.self) private var timerManager

    private func validateTimerInput() -> TimeInterval {

        let timesArray: [Int] = timerText.split(
            separator: ":"
        )
        .map(String.init)
        .compactMap { substring in
            // 1. Trim the whitespace from the substring
            let trimmed = substring.trimmingCharacters(in: .whitespaces)

            // 2. Try to convert to Int.
            // If it fails (returns nil), compactMap skips it.
            return Int(trimmed)
        }

        if timesArray.isEmpty {
            return 0
        }

        if timesArray.count == 1 {
            return TimeInterval(timesArray[0] * 60)
        }

        var seconds = timesArray[timesArray.count - 1]
        seconds += timesArray[timesArray.count - 2] * 60
        return TimeInterval(seconds)
    }
    
    var body: some View {
        HStack {
            if timerManager.timerStatus != .stopped {
                Text(
                    Duration.seconds(
                        timerManager.timeRemaining
                    ).formatted(.time(pattern: .minuteSecond))
                )
                .fontDesign(.monospaced)
                .foregroundColor(
                    Color(NSColor.disabledControlTextColor)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                TextField(
                    "00:00:00",
                    text: $timerText,
                )
                .labelsHidden()
                .fontDesign(.monospaced)
                .focused(isFocused)
                .onAppear {
                    isFocused.wrappedValue = true
                }
                .onDisappear {
                    isFocused.wrappedValue = false
                }
                .onTapGesture {
                    isFocused.wrappedValue = true
                }
                .onChange(of: isFocused.wrappedValue) {
                    oldValue,
                    newValue in
                    if newValue == false {
                        timerManager.setTimer(
                            duration: validateTimerInput()
                        )
                        timerText = Duration.seconds(
                            timerManager.getTimerDuration()
                        ).formatted(.time(pattern: .minuteSecond))
                    }
                }
                .onSubmit {
                    timerManager.setTimer(
                        duration: validateTimerInput()
                    )
                    timerText = Duration.seconds(
                        timerManager.getTimerDuration()
                    ).formatted(.time(pattern: .minuteSecond))
                    isFocused.wrappedValue = false
                }
            }

            Button {
                timerManager.stop()
            } label: {
                Image(systemName: "square.fill")
            }
            .disabled(timerManager.timerStatus == .stopped)

            Button {
                switch timerManager.timerStatus {
                case .running:
                    timerManager.pause()
                case .paused:
                    timerManager.resume()
                case .stopped:
                    timerManager.setTimer(
                        duration: validateTimerInput()
                    )
                    timerText = Duration.seconds(
                        timerManager.getTimerDuration()
                    ).formatted(.time(pattern: .minuteSecond))
                    timerManager.start()
                }

            } label: {
                Image(
                    systemName: timerManager.timerStatus == .running
                        ? "pause.fill" : "play.fill"
                )
            }
        }
    }
}

//#Preview {
//    TimerInput()
//}
