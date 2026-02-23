//
//  CountdownWidgetLiveActivity.swift
//  CountdownWidget
//
//  Created by Madeleine on 23.02.26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CountdownWidgetAttributes: ActivityAttributes {
    public typealias LiveDeliveryData = ContentState
     public struct ContentState: Codable, Hashable {
         // UserDefaults are used instead
     }

     var id = UUID()
}

extension CountdownWidgetAttributes {
    func prefixedKey(_ key: String) -> String { "\(id)_\(key)" }
}


let sharedDefault = UserDefaults(suiteName: "group.com.selbstlernen.app.ios")!

struct CountdownWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountdownWidgetAttributes.self) { context in
            let keys = context.attributes
            let isSimple      = sharedDefault.bool(forKey: keys.prefixedKey("isSimple"))
            let phaseName     = sharedDefault.string(forKey: keys.prefixedKey("currentPhase")) ?? ""
            let remainingMins = sharedDefault.integer(forKey: keys.prefixedKey("remainingMins"))
            let totalMins     = sharedDefault.integer(forKey: keys.prefixedKey("totalMins"))
            let isBreak       = sharedDefault.bool(forKey: keys.prefixedKey("isBreak"))
            let cycleNumber   = sharedDefault.integer(forKey: keys.prefixedKey("cycleNumber"))
            let totalCycles   = sharedDefault.integer(forKey: keys.prefixedKey("totalCycles"))
            
            LockScreenView(
                isSimple: isSimple,
                phaseName: phaseName,
                remainingMins: remainingMins,
                totalMins: totalMins,
                isBreak: isBreak,
                cycleNumber: cycleNumber,
                totalCycles: totalCycles
            )
            
        } dynamicIsland: { context in
            let keys = context.attributes
            let isSimple      = sharedDefault.bool(forKey: keys.prefixedKey("isSimple"))
            let phaseName     = sharedDefault.string(forKey: keys.prefixedKey("currentPhase")) ?? ""
            let remainingMins = sharedDefault.integer(forKey: keys.prefixedKey("remainingMins"))
            let totalMins     = sharedDefault.integer(forKey: keys.prefixedKey("totalMins"))
            let isBreak       = sharedDefault.bool(forKey: keys.prefixedKey("isBreak"))
            let cycleNumber   = sharedDefault.integer(forKey: keys.prefixedKey("cycleNumber"))
            let totalCycles   = sharedDefault.integer(forKey: keys.prefixedKey("totalCycles"))
            let progress      = totalMins > 0 ? Double(totalMins - remainingMins) / Double(totalMins) : 0
            
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isBreak ? "Break" : phaseName)
                            .font(.caption.weight(.semibold))
                            .foregroundColor(isBreak ? .green : .orange)
                        if !isSimple {
                            Text("Cycle \(cycleNumber)/\(totalCycles)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(remainingMins)m")
                        .font(.title3.monospacedDigit().weight(.bold))
                        .foregroundColor(isBreak ? .green : .orange)
                        .padding(.trailing, 4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: progress)
                        .tint(isBreak ? .green : .orange)
                        .padding(.horizontal, 4)
                }
            } compactLeading: {
                Image(systemName: isBreak ? "cup.and.saucer.fill" : "brain.head.profile")
                    .foregroundColor(isBreak ? .green : .orange)
                    .font(.caption)
            } compactTrailing: {
                Text("\(remainingMins)m")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(isBreak ? .green : .orange)
            } minimal: {
                Text("\(remainingMins)")
                    .font(.caption2.monospacedDigit())
            }
        }
    }
}
    struct LockScreenView: View {
        let isSimple: Bool
        let phaseName: String
        let remainingMins: Int
        let totalMins: Int
        let isBreak: Bool
        let cycleNumber: Int
        let totalCycles: Int

        private var progress: Double {
            guard totalMins > 0 else { return 0 }
            return Double(totalMins - remainingMins) / Double(totalMins)
        }

        private var accentColor: Color { isBreak ? .orange : .pink }

        var body: some View {
            VStack(spacing: 10) {
                if isSimple {
                    simpleView
                } else {
                    pomodoroView
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .activityBackgroundTint(Color.black.opacity(0.1))
            .activitySystemActionForegroundColor(Color.white)
        }

        // MARK: Simple: big countdown + progress bar
        var simpleView: some View {
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Image(systemName: isBreak ? "cup.and.saucer.fill" : "brain.head.profile")
                                .font(.system(size: 20))
                                .foregroundColor(accentColor)
                            
                            VStack(alignment: .leading){
                                Text("Fokus")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                Text("Verbleibende Zeit")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                           
                        }
                       
                       
                    }
                    Spacer()
                    
                    // Remaining mins
                    Text("\(remainingMins) min")
                        .font(.title2.monospacedDigit().weight(.semibold))
                        .foregroundColor(.primary)
                }

                // Linear progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(white:0.95))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(accentColor)
                            .frame(width: geo.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)
            }
        }

        // MARK: Pomodoro: phase + cycle dots + progress
        var pomodoroView: some View {
            VStack(spacing: 8) {
                HStack(alignment: .center) {
                    // Phase badge
                    HStack(spacing: 6) {
                        Image(systemName: isBreak ? "cup.and.saucer.fill" : "brain.head.profile")
                            .font(.system(size: 20))
                            .foregroundColor(accentColor)
                        
                        VStack(alignment: .leading){
                            Text(isBreak ? "Pause" : "Fokus")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            Text("Verbleibende Zeit")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()

                    // Remaining time + Intervals
                    VStack(alignment: .trailing, spacing: 2){
                        Text("\(remainingMins) min")
                            .font(.title2.monospacedDigit().weight(.semibold))
                            .foregroundColor(.primary)
                        
                        // Cycle dot indicators
                        HStack(spacing: 5) {
                            Text("Phase")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            ForEach(1...max(1, totalCycles), id: \.self) { i in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(i < cycleNumber
                                          ? accentColor                    // completed
                                          : i == cycleNumber
                                            ? accentColor.opacity(0.6)    // current
                                            :  Color(white: 0.9))  // upcoming
                                    .frame(width: 10, height: 10)
                                   
                            }
                          
                        }
                        
                    }
                    
                }


                // Phase progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(white: 0.9))
                            .frame(height: 5)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(accentColor)
                            .frame(width: geo.size.width * progress, height: 5)
                    }
                }
                .frame(height: 5)
            }
        }
    }

// MARK: - Previews
private func setupPreviewData(
    attributes: CountdownWidgetAttributes,
    isSimple: Bool,
    phaseName: String,
    remainingMins: Int,
    totalMins: Int,
    isBreak: Bool = false,
    cycleNumber: Int = 1,
    totalCycles: Int = 4
) {
    sharedDefault.set(isSimple,      forKey: attributes.prefixedKey("isSimple"))
    sharedDefault.set(phaseName,     forKey: attributes.prefixedKey("currentPhase"))
    sharedDefault.set(remainingMins, forKey: attributes.prefixedKey("remainingMins"))
    sharedDefault.set(totalMins,     forKey: attributes.prefixedKey("totalMins"))
    sharedDefault.set(isBreak,       forKey: attributes.prefixedKey("isBreak"))
    sharedDefault.set(cycleNumber,   forKey: attributes.prefixedKey("cycleNumber"))
    sharedDefault.set(totalCycles,   forKey: attributes.prefixedKey("totalCycles"))
}

#Preview("Simple Timer", as: .content, using: {
    let attrs = CountdownWidgetAttributes()
    setupPreviewData(attributes: attrs, isSimple: true,
                     phaseName: "Timer", remainingMins: 18, totalMins: 25)
    return attrs
}()) { CountdownWidgetLiveActivity() } contentStates: { CountdownWidgetAttributes.ContentState() }


#Preview("Pomodoro - Focus", as: .content, using: {
    let attrs = CountdownWidgetAttributes()
    setupPreviewData(attributes: attrs, isSimple: false,
                     phaseName: "Focus", remainingMins: 18, totalMins: 25, isBreak: false, cycleNumber: 2, totalCycles: 4)
    return attrs
}()) { CountdownWidgetLiveActivity() } contentStates: { CountdownWidgetAttributes.ContentState() }

#Preview("Pomodoro - Break", as: .content, using: {
    let attrs = CountdownWidgetAttributes()
    setupPreviewData(attributes: attrs, isSimple: false,
                     phaseName: "Break",remainingMins: 3, totalMins: 5, isBreak: true, cycleNumber: 2, totalCycles: 4)
    return attrs
}()) { CountdownWidgetLiveActivity() } contentStates: { CountdownWidgetAttributes.ContentState() }

