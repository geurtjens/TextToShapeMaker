//
//  ConvertShapesToArray.swift
//  
//
//  Created by Michael Geurtjens on 15/4/2023.
//

import Foundation
struct ConvertShapesToArray {
    static func execute(shapes:[ShapeModel], words: [String]) -> [[UInt8]] {
        var result:[[UInt8]] = []
        
        for shape in shapes {
            result.append(convertShapeToArray(shape: shape, words: words))
        }
        return result
    }
    
    static func convertShapeToArray(shape: ShapeModel,  words: [String]) -> [UInt8] {
        
        let initialArray = createInitialArrayForShape(shape: shape)
        
        let wordIds = convertPlacementsTo_WordId(placements: shape.placements, words: words)
        let isHorizontal = convertPlacementsTo_IsHorizontal(placements: shape.placements)
        let x = convertPlacementsTo_X(placements: shape.placements)
        let y = convertPlacementsTo_Y(placements: shape.placements)
        
        if wordIds.count == shape.placements.count {
            
            let result = initialArray + wordIds + isHorizontal + x + y

            return result
        } else {
            return []
        }
    }
    
    static func createInitialArrayForShape(shape: ShapeModel) -> [UInt8] {
        let score = (shape.score - (10 * shape.placements.count)) / 2
        
        let score_UInt8 = UInt8(score)
        
        let wordCount_UInt8 = UInt8(shape.placements.count)
        
        let width_UInt8 = UInt8(shape.width)
        
        let height_UInt8 = UInt8(shape.height)
        
        
        
        var array: [UInt8] = [wordCount_UInt8, score_UInt8, width_UInt8, height_UInt8]
        return array
    }
    
    static func findWordId(word: String, words:[String]) -> Int {
        for i in words.indices {
            if word == words[i] {
                return i
            }
        }
        return -1
    }
    
    
    static func convertPlacementsTo_WordId(placements:[PlacementModel], words:[String]) -> [UInt8] {
        var result:[UInt8] = []
        for placement in placements {
            let wordId = findWordId(word:placement.word, words:words)
            
            let wordId_UInt8 = UInt8(wordId)
            result.append(wordId_UInt8)
        }
        return result
    }
    
    static func convertPlacementsTo_IsHorizontal(placements:[PlacementModel]) -> [UInt8] {
        var result:[UInt8] = []
        for placement in placements {
            if placement.isHorizontal {
                result.append(UInt8(1))
            } else {
                result.append(UInt8(0))
            }
        }
        return result
    }
    
    static func convertPlacementsTo_X(placements:[PlacementModel]) -> [UInt8] {
        var result:[UInt8] = []
        for placement in placements {
            result.append(UInt8(placement.x))
        }
        return result
    }
    
    static func convertPlacementsTo_Y(placements:[PlacementModel]) -> [UInt8] {
        var result:[UInt8] = []
        for placement in placements {
            result.append(UInt8(placement.y))
        }
        return result
    }
    
    
}
