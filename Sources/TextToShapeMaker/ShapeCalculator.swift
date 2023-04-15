//
//  ShapeCalculator.swift
//  
//
//  Created by Michael Geurtjens on 11/4/2023.
//

import Foundation
struct ShapeCalculator {
    static func execute(placements: [PlacementModel]) -> ShapeModel {
        // We have to add the blocks at the end of everything
        let (maxX, maxY) = calcMax(placements: placements)
        
        let width = maxX + 2
        let height = maxY + 2
        
        // We have to add blocking characters which increases size by 2 in both directions
        var grid = calcGrid(width: width, height: height)

        var score = 0
        for placement in placements {
            score += 10
            
            var x1 = placement.x
            var y1 = placement.y
            var x2 = x1
            var y2 = y1
            if placement.isHorizontal {
                y1 += 1
                y2 = y1
                x2 = x1 + placement.word.count + 1
            } else {
                x1 += 1
                x2 = x1
                y2 = y1 + placement.word.count + 1
            }
            
            let blockStartValue = grid[y1][x1]
            if blockStartValue == "."
            {} else if blockStartValue == " " {
                grid[y1][x1] = "."
            } else {
                grid[y1][x1] = "#"
            }
            
            // Now we add the end blocking character
            let blockEndValue = grid[y2][x2]
            if blockEndValue == "."
            {} else if blockEndValue == " " {
                grid[y2][x2] = "."
            } else {
                grid[y2][x2] = "#"
            }
            
            for i in 0..<placement.word.count {
                var x = 0
                var y = 0
                if placement.isHorizontal {
                    x = placement.x + i + 1
                    y = placement.y + 1
                } else {
                    x = placement.x + 1
                    y = placement.y + i + 1
                }
                
                let currentValue = grid[y][x]
                if currentValue == String(placement.word[i]) {
                    score += ScoreCalculator.LetterScore(letter: currentValue[0])
                } else if currentValue == " " {
                    grid[y][x] = String(placement.word[i])
                } else {
                    grid[y][x] = "#"
                }
            }
        }
        let shapeText = convertToString(grid:grid)
        
        if shapeText.contains("#") {
            score = 0
        }
        
        let fixedPlacements = fixPlacements(placements: placements)
        
        let shape = ShapeModel(score: score, width: width, height: height, placements: fixedPlacements, text: shapeText)
        
        return shape
        
    }
    
    /// When we use create shape it adds +1 offsets for each placement so we must reverse that if we want to convert placements into a shape
    static func allowForBlockOffsetsBeingAppliedLater(placements: [PlacementModel]) -> [PlacementModel] {
        var result: [PlacementModel] = []
        for placement in placements {
            if placement.isHorizontal {
                result.append(PlacementModel(word: placement.word, isHorizontal: placement.isHorizontal, x: placement.x, y: placement.y - 1))
            } else {
                result.append(PlacementModel(word: placement.word, isHorizontal: placement.isHorizontal, x: placement.x - 1, y: placement.y))
            }
        }
        return result
    }
    
    static func fixPlacements(placements: [PlacementModel]) -> [PlacementModel] {
        var result: [PlacementModel] = []
        for p in placements {
            if p.isHorizontal {
                result.append(PlacementModel(word: p.word, isHorizontal: p.isHorizontal, x: p.x, y: p.y + 1 ))
            } else {
                result.append(PlacementModel(word: p.word, isHorizontal: p.isHorizontal, x: p.x + 1, y: p.y ))
            }
        }
        return result
    }
    static func convertToString(grid:[[String]]) -> String {
        // Then we just concatinate everything together
        var shapeText = ""
        for row in grid {
            for column in row {
                shapeText += column
            }
            shapeText += "\n"
        }
        
        // remove the last character /n
        shapeText = String(shapeText.dropLast())
        return shapeText
    }
    // We want to create a structure to hold all of these values into
    
    static func calcGrid(width: Int, height: Int) -> [[String]] {
        let xArray: [String] = Array(repeating: " ", count: width)
        
        let result: [[String]] = Array(repeating: xArray, count: height)
        return result
    }
    
    static func calcMax(placements:[PlacementModel]) -> (Int, Int) {
        if placements.count == 0 {
            return (0, 0)
        }
        
        var maxX = 0
        var maxY = 0
        
        for i in 0..<placements.count {
            
            let placement = placements[i]

            let wordLength = placement.word.count
            
            if placement.isHorizontal {
                if maxY < placement.y {
                    maxY = placement.y
                }
                if maxX < placement.x + wordLength {
                    maxX = placement.x + wordLength
                }
            } else {
                if maxX < placement.x {
                    maxX = placement.x
                }
                if maxY < placement.y + wordLength {
                    maxY = placement.y + wordLength
                }
            }
        }
        return (maxX, maxY)
    }
}
