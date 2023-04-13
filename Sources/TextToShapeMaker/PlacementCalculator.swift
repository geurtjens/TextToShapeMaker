//
//  File.swift
//  
//
//  Created by Michael Geurtjens on 9/4/2023.
//

import Foundation
struct PlacementCalculator {
    
    static func execute(instructions: [InstructionModel]) -> [PlacementModel] {
        if isValid(input: instructions) == false {
            return []
        }

        // Start the list off with first two words
        var placements = placeFirst(item: instructions[0])
        
        for i in 1..<instructions.count {
            // Now we go through each item placing it into the array and finding its relative position
            
            let instruction = instructions[i]
            
            // In a square it finds the first one which is actually matching the right word
            let matchingPlacement = findPlacement(placements: placements, instruction: instruction)
            
            if let matchingPlacement = matchingPlacement {

                if matchingPlacement.word == instruction.fromWord {
                    
                    placements.append(createPlacement(
                        placement:matchingPlacement,
                        word: instruction.toWord,
                        placementIntersection: instruction.fromPos,
                        wordIntersection: instruction.toPos))
                   
                } else if matchingPlacement.word == instruction.toWord {

                    placements.append(createPlacement(
                        placement:matchingPlacement,
                        word: instruction.fromWord,
                        placementIntersection: instruction.toPos,
                        wordIntersection: instruction.fromPos))
                    
                }
            }
            
        }
            
        // Next we work out the offset by calculating the minimum x and y
        let (offset_x, offset_y) = findOffsets(placements:placements)
        
        // So we then make a new set of placements with the minimums recalculated
        let result = applyOffset(placements:placements, offset_x: offset_x, offset_y: offset_y)
        
        return result
    }
    
    static func createPlacement(placement: PlacementModel, word: String, placementIntersection: Int, wordIntersection: Int) -> PlacementModel {
        let isHorizontal = !placement.isHorizontal
        
        if isHorizontal {
            let x = placement.x - wordIntersection
            let y = placement.y + placementIntersection
            return PlacementModel(word: word, isHorizontal: isHorizontal, x: x, y: y)
        } else {
            let x = placement.x + placementIntersection
            let y = placement.y - wordIntersection
            return PlacementModel(word: word, isHorizontal: isHorizontal, x: x, y: y)
        }
    }
    static func findPlacement(placements: [PlacementModel], instruction: InstructionModel) -> PlacementModel? {
        
        for placement in placements {
            if placement.word == instruction.fromWord || placement.word == instruction.toWord {
                return placement
            }
        }
        return nil
        
    }
    
    static func findOffsets(placements: [PlacementModel]) -> (Int, Int) {
        
        if placements.count == 0 {
            return (0,0)
        }
        var x = placements[0].x
        var y = placements[0].y
        
        for i in 1..<placements.count {
            if x > placements[i].x {
                x = placements[i].x
            }
            if y > placements[i].y {
                y = placements[i].y
            }
        }
        return (x, y)
    }
    static func applyOffset(placements:[PlacementModel], offset_x: Int, offset_y: Int) -> [PlacementModel] {
        var result: [PlacementModel] = []
        for placement in placements {
            result.append(PlacementModel(word: placement.word,
                                         isHorizontal: placement.isHorizontal,
                                         x: placement.x - offset_x,
                                         y: placement.y - offset_y))
        }
        return result
    }
    
    static func placeFirst(item: InstructionModel) -> [PlacementModel] {
        let firstLeft = PlacementModel(
            word: item.fromWord,
            isHorizontal: true,
            x: 0,
            y: 0)
        
        let firstRight = PlacementModel(
            word: item.toWord,
            isHorizontal: false,
            x: item.fromPos,
            y: -item.toPos)
        
        let result = [firstLeft, firstRight]
        return result
        
    }
    
    static func isValid(input: [InstructionModel]) -> Bool {
        for item in input {
            if item.isValid != .success {
                return false
            }
        }
        return true
    }
}
