//
//  FlyweightRealExample.swift
//  FlyweightReal
//
//  Created by Maxim Eremenko on 7/11/18.
//  Copyright © 2018 Eremenko Maxim. All rights reserved.
//

import XCTest
import UIKit

class FlyweightRealExample: XCTestCase {
    
    func testFlyweight() {
        
        let maineCoon = Animal(name: "Maine Coon",
                         country: "USA",
                         type: .cat)
        
        let sphynx = Animal(name: "Sphynx",
                         country: "Egypt",
                         type: .cat)
        
        let bulldog = Animal(name: "Bulldog",
                         country: "England",
                         type: .dog)
        
        print("Client: I created a number of objects to display")
        
        /// Displaying objects for the 1-st time.

        print("Client: Let's show animals for the 1st time\n")
        display(animals: [maineCoon, sphynx, bulldog])
        
        
        /// Displaying objects for the 2-nd time.
        ///
        /// Note: Cached object of the appearance will be reused this time.
        
        print("\nClient: I have a new dog, let's show it the same way!\n")
        
        let germanShepherd = Animal(name: "German Shepherd",
                              country: "Germany",
                              type: .dog)
        
        display(animals: [germanShepherd])
    }
    
    func display(animals: [Animal]) {
        
        var cells = loadCells(count: animals.count)
        
        for index in 0..<animals.count {
            cells[index].update(with: animals[index])
        }
        
        print("Using updated cells (count: \(cells.count))\n")
    }
    
    func loadCells(count: Int) -> [Cell] {
        /// Emulates behavior of a table/collection view.
        return Array(repeating: Cell(), count: count)
    }
}

enum Type: String {
    case cat
    case dog
}

class Cell {
    
    private var animal: Animal?
    
    func update(with animal: Animal) {
        self.animal = animal
        update(appearance: animal.appearance)
    }
    
    private func update(appearance: Appearance) {
        print("Updating appearance of a \(appearance.key.rawValue)-cell.\n")
    }
}

struct Animal {
    
    /// This is an external context that contains specific values
    /// and object with a common state.
    ///
    /// Note: The object of appearance will be lazily created when it's needed
    
    let name: String
    let country: String
    let type: Type
    
    var appearance: Appearance {
        return AppearanceFactory.info(for: type)
    }
}

struct Appearance {
    
    /// This object contains a predefined appearance of every cell
    
    let key: Type
    let photos: [UIImage]
    let backgroundColor: UIColor
    let animation: CAAnimation
}

class AppearanceFactory {
    
    private static var cache = [Type: Appearance]()
    
    static func info(for key: Type) -> Appearance {
        
        guard cache[key] == nil else {
            print("AppearanceFactory: Reusing an existing \(key.rawValue)-appearance.")
            return cache[key]!
        }
        
        print("AppearanceFactory: Can't find a cached \(key.rawValue)-object, creating a new one.")
        
        switch key {
        case .cat:
            cache[key] = catInfo
        case .dog:
            cache[key] = dogInfo
        }
        
        return cache[key]!
    }
    
    private static var catInfo: Appearance {
        return Appearance(key: .cat,
                    photos: [UIImage()],
                    backgroundColor: .red,
                    animation: CABasicAnimation())
    }
    
    private static var dogInfo: Appearance {
        return Appearance(key: .dog,
                    photos: [UIImage(), UIImage()],
                    backgroundColor: .blue,
                    animation: CAKeyframeAnimation())
    }
}