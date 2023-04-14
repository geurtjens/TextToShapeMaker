//
//  ShapeCalculator_Tests.swift
//  
//
//  Created by Michael Geurtjens on 11/4/2023.
//

import XCTest
@testable import TextToShapeMaker
final class ShapeCalculator_Tests: XCTestCase {

    func test_another() throws {
    
        let instructions = InstructionParser.execute("nAZARETH:nUTS,NAzARETH:zION,NUTs:sING")
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        print(shape.text)
    }
    
    func test_usingSequencer() throws {
    
        let unsequencedInstructions = InstructionParser.execute("nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + JOy:HOLLy + jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + TURKEy:HyMN + TuRKEY:SAuCE + tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + TOyS:FAMILy + INn:HYMn + TURkEY:PORk + WHiTE:FAMiLY + wHITE:SNOw + WHITe:CAKe")
        
        let (myStringInstructions, _, _) = InstructionSequencer.executeGivingText(instructions: unsequencedInstructions)
        let (instructions, success, wordsInShape) = InstructionSequencer.execute(instructions: unsequencedInstructions)
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        print(shape.text)
        print(success)
        print(myStringInstructions)
        print(wordsInShape)
        
        
        
        // This is the order that words are placed in the grid according to the instructions given
        let wordsInShapeExpected = ["NAZARETH", "NUTS", "ZION", "SING", "EVE", "HOLLY", "BELLS", "JOY", "JELLY", "HAZELNUT", "STAR", "AZURE", "MERRY", "HYMN", "TURKEY", "SAUCE", "TOYS", "TOAST", "TREE", "FAMILY", "INN", "PORK", "WHITE", "SNOW", "CAKE"]
        XCTAssertEqual(wordsInShapeExpected.count, wordsInShape.count)
        for i in wordsInShape.indices {
            XCTAssertEqual(wordsInShapeExpected[i], wordsInShape[i])
        }
        
    }
    
    func test_OneRotated() throws {
        let instructions = InstructionParser.execute("!MiCHAEL:KAORi")
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        
        let expected = "" +
          "     . \n" +
          "     M \n" +
          ".KAORI.\n" +
          "     C \n" +
          "     H \n" +
          "     A \n" +
          "     E \n" +
          "     L \n" +
          "     . "
        
        XCTAssertEqual(expected, shape.text)
        XCTAssertEqual(24, shape.score)
        XCTAssertEqual(7, shape.width)
        XCTAssertEqual(9, shape.height)
        
        XCTAssertEqual(2, shape.placements.count)
        
        let a = shape.placements[0]
        XCTAssertEqual("KAORI", a.word)
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(2, a.y)
        
        let b = shape.placements[1]
        XCTAssertEqual("MICHAEL", b.word)
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual(5, b.x)
        XCTAssertEqual(0, b.y)
        
        print(shape.text)
    }
    
    func test_One() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi")
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        
        let expected = "" +
          "  .      \n" +
          "  K      \n" +
          "  A      \n" +
          "  O      \n" +
          "  R      \n" +
          ".MICHAEL.\n" +
          "  .      "
          
        XCTAssertEqual(expected, shape.text)
        XCTAssertEqual(24, shape.score)
        XCTAssertEqual(9, shape.width)
        XCTAssertEqual(7, shape.height)
        
        XCTAssertEqual(2, shape.placements.count)
        
        let a = shape.placements[0]
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(5, a.y)
        
        let b = shape.placements[1]
        XCTAssertEqual("KAORI", b.word)
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual(2, b.x)
        XCTAssertEqual(0, b.y)
        
        
        //print(shape.text)
    }
    
    func test_Two() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi,MICHAEl:lISA")
        
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        
        let expected = "" +
          "  .      \n" +
          "  K      \n" +
          "  A      \n" +
          "  O      \n" +
          "  R    . \n" +
          ".MICHAEL.\n" +
          "  .    I \n" +
          "       S \n" +
          "       A \n" +
          "       . "
        XCTAssertEqual(expected, shape.text)
        XCTAssertEqual(38, shape.score)
        XCTAssertEqual(9, shape.width)
        XCTAssertEqual(10, shape.height)
        
        XCTAssertEqual(3, shape.placements.count)
        
        let a = shape.placements[0]
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(5, a.y)
        
        let b = shape.placements[1]
        XCTAssertEqual("KAORI", b.word)
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual(2, b.x)
        XCTAssertEqual(0, b.y)
        
        let c = shape.placements[2]
        XCTAssertEqual("LISA", c.word)
        XCTAssertFalse(c.isHorizontal)
        XCTAssertEqual(7, c.x)
        XCTAssertEqual(4, c.y)
        
        
        //print(shape.text)
    }
    
    func test_Three() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi,MICHAEl:lISA,LISa:SaNDY")
        
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        
        let expected = "" +
          "  .         \n" +
          "  K         \n" +
          "  A         \n" +
          "  O         \n" +
          "  R    .    \n" +
          ".MICHAEL.   \n" +
          "  .    I    \n" +
          "       S    \n" +
          "     .SANDY.\n" +
          "       .    "
        XCTAssertEqual(expected, shape.text)
        XCTAssertEqual(50, shape.score)
        XCTAssertEqual(12, shape.width)
        XCTAssertEqual(10, shape.height)
        
        XCTAssertEqual(4, shape.placements.count)
        
        let a = shape.placements[0]
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(5, a.y)
        
        let b = shape.placements[1]
        XCTAssertEqual("KAORI", b.word)
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual(2, b.x)
        XCTAssertEqual(0, b.y)
        
        let c = shape.placements[2]
        XCTAssertEqual("LISA", c.word)
        XCTAssertFalse(c.isHorizontal)
        XCTAssertEqual(7, c.x)
        XCTAssertEqual(4, c.y)
        
        let d = shape.placements[3]
        XCTAssertEqual("SANDY", d.word)
        XCTAssertTrue(d.isHorizontal)
        XCTAssertEqual(5, d.x)
        XCTAssertEqual(8, d.y)
        
        //print(shape.text)
    }
    
    func test_SquareReversed() throws {
        let instructions = InstructionParser.execute("!ABc:cEH,CEh:FGh,fGH:ADf")
        
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        
        let expected = "" +
          " . . \n" +
          ".ADF.\n" +
          " B G \n" +
          ".CEH.\n" +
          " . . "
        XCTAssertEqual(expected, shape.text)
        //print(shape.text)
    }
    
    func test_Square() throws {
        let instructions = InstructionParser.execute("ABc:cEH,CEh:FGh,fGH:ADf")
        
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        
        let expected = "" +
          " . . \n" +
          ".ABC.\n" +
          " D E \n" +
          ".FGH.\n" +
          " . . "
        XCTAssertEqual(expected, shape.text)
        //print(shape.text)
    }	
    
    func testTwoByTwo9005() throws {
        let instructions = InstructionParser.execute("TENOr:TrIO,TRiO:PiNZA,pINZA:OpUS,TRIo:DUo")
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        print(shape.text)
    }
    // You can join these two together to form what is in 9005
    func testTwoByTwo9005_2() throws {
        let instructions = InstructionParser.execute("dUO:dUET,DuET:CHORuS,DuO:OPuS")
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        print(shape.text)
    }
    
    func testMerge9005() throws {
        let instructions = InstructionParser.execute("TENOr:TrIO,TRiO:PiNZA,pINZA:OpUS,TRIo:DUo + dUO:dUET,DuET:CHORuS,DuO:OPuS")
        let placements = PlacementCalculator.execute(instructions: instructions)
        let shape = ShapeCalculator.execute(placements: placements)
        print(shape.text)
    }
    
}
