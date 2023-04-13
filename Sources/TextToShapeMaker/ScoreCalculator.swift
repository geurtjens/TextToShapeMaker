//
//  ScoreCalculator.swift
//  
//
//  Created by Michael Geurtjens on 11/4/2023.
//

import Foundation
struct ScoreCalculator {
    /*
     Z      = 64
     Y      = 32
     STUVWX = 16
     MNOPQR = 8
     GHIJKL = 4
     ABCDEF = 2
     */
    static func LetterScore(letter: Character) -> Int {
        if letter == "Z" {
            return 64
        } else if letter == "Y" {
            return 32
        } else if letter >= "S" && letter <= "X" {
            return 16
        } else if letter >= "M" && letter <= "R" {
            return 8
        } else if letter >= "G" && letter <= "L" {
            return 4
        } else if letter >= "A" && letter <= "F" {
            return 2
        }
        return 0
    }
    
}
