//
//  PetriGardenVM.swift
//  OrganismSwiftUI
//
//  Created by 张文涛 on 2023/4/14.
//

import Foundation

class PetriGardenVM: ObservableObject{
    @Published var model = PetriGardenModel(dishName: "Dish", timeStamp: .now)
}
