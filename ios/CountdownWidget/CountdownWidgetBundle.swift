//
//  CountdownWidgetBundle.swift
//  CountdownWidget
//
//  Created by Madeleine on 23.02.26.
//

import WidgetKit
import SwiftUI

@main
struct CountdownWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountdownWidget()
        CountdownWidgetLiveActivity()
    }
}
