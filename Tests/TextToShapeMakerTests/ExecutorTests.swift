//
//  ExecutorTests.swift
//  
//
//  Created by Michael Geurtjens on 13/4/2023.
//

import XCTest
@testable import TextToShapeMaker
final class ExecutorTests: XCTestCase {

    func test_8612() throws {
    
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + JOy:HOLLy + jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + TURKEy:HyMN + TuRKEY:SAuCE + tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + TOyS:FAMILy + INn:HYMn + TURkEY:PORk + WHiTE:FAMiLY + wHITE:SNOw + WHITe:CAKe"
        
        let (shape, success) = Executor.execute(input)
        
        let expected = "" +
            " . . . . .  . .  \n" +
            " S F C.NAZARETH. \n" +
            " N A A U I  V O  \n" +
            " O M K T O.BELLS.\n" +
            ".WHITE.SING.. L  \n" +
            " . L..P. ...JOY. \n" +
            ".TOYS.O . A E .S \n" +
            " O .A R.HAZELNUT.\n" +
            " A.TURKEY.U L  A \n" +
            " S  C ..MERRY. R \n" +
            ".TREE.INN.E .  . \n" +
            " .  .   . .      "
        
        XCTAssertEqual(expected, shape.text)
        XCTAssertTrue(success)
        XCTAssertEqual(694, shape.score)
        XCTAssertEqual(17, shape.width)
        XCTAssertEqual(12, shape.height)
        print(shape.text)
        
    
    }

}

