//
//  PetriGardenVM.swift
//  OrganismSwiftUI
//
//  Created by 张文涛 on 2023/4/14.
//

import Foundation

class PetriGardenVM: ObservableObject{
    @Published var model = PetriGardenModel(dishName: "Dish", timeStamp: .now)
    var point = [1,1]
    func printMap()->Void {
        // x
        for i in 1...19{
            point[0] = i
            // y
            for j in 1...19{
                point[1] = j
                print(point)
            }
        }
    }

}
