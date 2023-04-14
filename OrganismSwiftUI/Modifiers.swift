//
//  Modifiers.swift
//  OrganismSwiftUI
//
//  Created by 张文涛 on 2023/4/14.
//

import SwiftUI

struct BgColor: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color("bgColor").ignoresSafeArea()
            content
        }
    }
}
