//
//  PlacementCalculator_Tests.swift
//  
//
//  Created by Michael Geurtjens on 11/4/2023.
//

import XCTest
@testable import TextToShapeMaker
final class PlacementCalculator_Tests: XCTestCase {

    func test_OneInstruction() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi")
        
        let placements = PlacementCalculator.execute(instructions: instructions)

        XCTAssertEqual(2, placements.count)
        
        let a = placements[0]
        
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(4, a.y)
        
        let b = placements[1]
        
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual("KAORI", b.word)
        XCTAssertEqual(1, b.x)
        XCTAssertEqual(0, b.y)
        
        
        /*
          K
          A
          O
          R
         MICHAEL
         */
        
    }

    func test_TwoInstructions_ConnectToRight() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi,kAORI:kAREN")
        
        let placements = PlacementCalculator.execute(instructions: instructions)

        XCTAssertEqual(3, placements.count)
        
        let a = placements[0]
        
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(4, a.y)
        
        let b = placements[1]
        
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual("KAORI", b.word)
        XCTAssertEqual(1, b.x)
        XCTAssertEqual(0, b.y)
        
        let c = placements[2]
        
        XCTAssertTrue(c.isHorizontal)
        XCTAssertEqual("KAREN", c.word)
        XCTAssertEqual(1, c.x)
        XCTAssertEqual(0, c.y)
        
        /*
          KAREN
          A
          O
          R
         MICHAEL
         */
        
    }

    func test_TwoInstructions_ConnectToLeft() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi,MICHAEl:lISA")
        
        let placements = PlacementCalculator.execute(instructions: instructions)

        XCTAssertEqual(3, placements.count)
        
        let a = placements[0]
        
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(4, a.y)
        
        let b = placements[1]
        
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual("KAORI", b.word)
        XCTAssertEqual(1, b.x)
        XCTAssertEqual(0, b.y)
        
        let c = placements[2]
        
        XCTAssertFalse(c.isHorizontal)
        XCTAssertEqual("LISA", c.word)
        XCTAssertEqual(6, c.x)
        XCTAssertEqual(4, c.y)
        
        /*
          K
          A
          O
          R
         MICHAEL
               I
               S
               A
         */
        
    }
    
    func test_ThreeInstructions_ConnectToLeft() throws {
        let instructions = InstructionParser.execute("MICHAEl:lISA,LISa:SaNDY")
        
        let placements = PlacementCalculator.execute(instructions: instructions)

        XCTAssertEqual(3, placements.count)
        
        let a = placements[0]
        
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(0, a.y)
        
        let b = placements[1]
        
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual("LISA", b.word)
        XCTAssertEqual(6, b.x)
        XCTAssertEqual(0, b.y)
        
        let c = placements[2]
        
        XCTAssertTrue(c.isHorizontal)
        XCTAssertEqual("SANDY", c.word)
        XCTAssertEqual(5, c.x)
        XCTAssertEqual(3, c.y)
        
        /*
         MICHAEL
               I
               S
              SANDY
         */
        
    }
    
    func test_ThreeInstructions_ConnectToLeft2() throws {
        let instructions = InstructionParser.execute("MiCHAEL:KAORi,MICHAEl:lISA,LISa:SaNDY")
        
        let placements = PlacementCalculator.execute(instructions: instructions)

        XCTAssertEqual(4, placements.count)
        
        let a = placements[0]
        
        XCTAssertTrue(a.isHorizontal)
        XCTAssertEqual("MICHAEL", a.word)
        XCTAssertEqual(0, a.x)
        XCTAssertEqual(4, a.y)
        
        let b = placements[1]
        
        XCTAssertFalse(b.isHorizontal)
        XCTAssertEqual("KAORI", b.word)
        XCTAssertEqual(1, b.x)
        XCTAssertEqual(0, b.y)
        
        let c = placements[2]
        
        XCTAssertFalse(c.isHorizontal)
        XCTAssertEqual("LISA", c.word)
        XCTAssertEqual(6, c.x)
        XCTAssertEqual(4, c.y)
        
        let d = placements[3]
        
        XCTAssertTrue(d.isHorizontal)
        XCTAssertEqual("SANDY", d.word)
        XCTAssertEqual(5, d.x)
        XCTAssertEqual(7, d.y)
        
        /*
          K
          A
          O
          R
         MICHAEL
               I
               S
              SANDY
         */
        
    }
}
