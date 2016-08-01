//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    
    var cells: [GridLocation] {
        get {
            let start = self.location
            var occupiedCells = [GridLocation]()

            for position in 0..<length {
                if isVertical {
                    occupiedCells.append(GridLocation(x: start.x, y: start.y + position))
                } else {
                    occupiedCells.append(GridLocation(x: start.x + position, y: start.y))
                }
            }
            
            return occupiedCells
        }
    }
    
    var hitTracker: HitTracker
    var sunk: Bool {
        var hits = 0
        for cell in hitTracker.cellsHit {
            if cell.1 {
                hits += 1
            }
        }
        return hits == length
    }

    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.init(length: length, location: location, isVertical: isVertical, isWooden: false)
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
}

protocol PenaltyCell {
    var location: GridLocation {get}
    var penaltyText: String {get}
    var guaranteesHit: Bool {get}
}

struct Mine: PenaltyCell {
    let location: GridLocation
    var penaltyText: String
    var guaranteesHit: Bool
    
    init(location: GridLocation, penaltyText: String, guaranteesHit: Bool) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = guaranteesHit
    }
    
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = false
    }
}

struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var penaltyText: String {
        return "RAWR 🐙"
    }
    var guaranteesHit: Bool {
        return true
    }
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: false)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: true)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: true)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        human.addShipToGrid(xLargeShip)
    
        let mine1 = Mine(location: GridLocation(x: 6, y: 0), penaltyText: "KABOOM! 💣💣💣")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "That's will teach him a lesson", guaranteesHit: true)
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6))
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2))
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}