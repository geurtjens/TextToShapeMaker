//
//  ConvertInterlockTextTo_Tests.swift
//  
//
//  Created by Michael Geurtjens on 13/4/2023.
//

import XCTest
@testable import TextToShapeMaker
final class ConvertInterlockTextTo_Tests: XCTestCase {

    
    func test_shapesArray() throws {
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn"
        
        let (arrayResult,success,wordsInGrid) = ConvertInterlockTextTo.shapesArray(input)
        
        let z = arrayResult[0]
        
        let (shape,success2,wordsInGrid2) = ConvertInterlockTextTo.shape(input)
        
        let wordCount = Int(z[0])
        let interlockScore = Int(z[1])
        let width = Int(z[2])
        let height = Int(z[3])
        
        let w1 = Int(z[4])
        let w2 = Int(z[5])
        let w3 = Int(z[6])
        let w4 = Int(z[7])
        
        let h1 = Int(z[8]) == 1
        let h2 = Int(z[9]) == 1
        let h3 = Int(z[10]) == 1
        let h4 = Int(z[11]) == 1
        
        let x1 = Int(z[12])
        let x2 = Int(z[13])
        let x3 = Int(z[14])
        let x4 = Int(z[15])
        
        let y1 = Int(z[16])
        let y2 = Int(z[17])
        let y3 = Int(z[18])
        let y4 = Int(z[19])
       
        
        let score = interlockScore * 2 + wordCount * 10
        
        XCTAssertEqual(shape.placements.count, wordCount)
        XCTAssertEqual(shape.width, width)
        XCTAssertEqual(shape.height, height)
        XCTAssertEqual(shape.score, score)
        print(shape.score, score)
        let a = shape.placements[0]
        let b = shape.placements[1]
        let c = shape.placements[2]
        let d = shape.placements[3]
        
        XCTAssertEqual(a.word, wordsInGrid[w1])
        XCTAssertEqual(b.word, wordsInGrid[w2])
        XCTAssertEqual(c.word, wordsInGrid[w3])
        XCTAssertEqual(d.word, wordsInGrid[w4])

        XCTAssertEqual(a.isHorizontal, h1)
        XCTAssertEqual(b.isHorizontal, h2)
        XCTAssertEqual(c.isHorizontal, h3)
        XCTAssertEqual(d.isHorizontal, h4)
        
        
        XCTAssertEqual(a.x, x1)
        XCTAssertEqual(b.x, x2)
        XCTAssertEqual(c.x, x3)
        XCTAssertEqual(d.x, x4)

        XCTAssertEqual(a.y, y1)
        XCTAssertEqual(b.y, y2)
        XCTAssertEqual(c.y, y3)
        XCTAssertEqual(d.y, y4)

        
    }
    
    
    func test_8612() throws {
    
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + JOy:HOLLy + jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + TURKEy:HyMN + TuRKEY:SAuCE + tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + TOyS:FAMILy + INn:HYMn + TURkEY:PORk + WHiTE:FAMiLY + wHITE:SNOw + WHITe:CAKe"
        
        let (shape, success, wordsInShape) = ConvertInterlockTextTo.shape(input)
        
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
        print(wordsInShape)
        
    
    }

    func test_8612_Shapes() throws {
    
        let input = "nAZARETH:nUTS,NAzARETH:zION,sING:NUTs,SInG:ZIOn + NAZAReTH:eVE,NAZARETh:hOLLY,BeLLS:EVe,BELlS:HOlLY + JOy:HOLLy + jOY:jELLY,HAZElNUT:JElLY,HAZELNUt:StAR + HAzELNUT:AzURE,HAZElNUT:JElLY,MErRY:AZUrE,MERRy:JELLy + hAZELNUT:hYMN,HAzELNUT:AzURE,mERRY:HYmN,MErRY:AZUrE + TURKEy:HyMN + TuRKEY:SAuCE + tOYS:tOAST,TOYs:sAUCE,tREE:TOASt,TREe:SAUCe + TOyS:FAMILy + INn:HYMn + TURkEY:PORk + WHiTE:FAMiLY + wHITE:SNOw + WHITe:CAKe"
        
        let (shapes, success, wordsInShapes) = ConvertInterlockTextTo.shapes(input)
        
        print(wordsInShapes)
        XCTAssertTrue(success)
        XCTAssertEqual(15, shapes.count)
        
        let a0 = shapes[0];
        let a1 = shapes[1];
        let a2 = shapes[2];
        let a3 = shapes[3];
        let a4 = shapes[4];
        let a5 = shapes[5];
        let a6 = shapes[6];
        let a7 = shapes[7];
        let a8 = shapes[8];
        let a9 = shapes[9];
        let a10 = shapes[10];
        let a11 = shapes[11];
        let a12 = shapes[12];
        let a13 = shapes[13];
        let a14 = shapes[14];
        
        
        let a0_e = "" +
        " . .      \n" +
        ".nAzARETH.\n" +
        " U I      \n" +
        " T O      \n" +
        ".sInG.    \n" +
        " . .      "
        XCTAssertEqual(a0_e.uppercased(), a0.text)
        XCTAssertEqual(136, a0.score)
        XCTAssertEqual(10, a0.width)
        XCTAssertEqual(6, a0.height)
        
        let a1_e = "" +
        "      . .  \n" +
        ".NAZAReTh. \n" +
        "      V O  \n" +
        "    .BeLlS.\n" +
        "      . L  \n" +
        "        Y  \n" +
        "        .  "
        XCTAssertEqual(a1_e.uppercased(), a1.text)
        XCTAssertEqual(52, a1.score)
        XCTAssertEqual(11, a1.width)
        XCTAssertEqual(7, a1.height)
        
        let a2_e = "" +
        "   . \n" +
        "   H \n" +
        "   O \n" +
        "   L \n" +
        "   L \n" +
        ".JOy.\n" +
        "   . "
        XCTAssertEqual(a2_e.uppercased(), a2.text)
        XCTAssertEqual(52, a2.score)
        XCTAssertEqual(5, a2.width)
        XCTAssertEqual(7, a2.height)
        
        let a3_e = "" +
        "     .    \n" +
        "    .jOY. \n" +
        "     E  S \n" +
        ".HAZElNUt.\n" +
        "     L  A \n" +
        "     Y  R \n" +
        "     .  . "
        XCTAssertEqual(a3_e.uppercased(), a3.text)
        XCTAssertEqual(64, a3.score)
        XCTAssertEqual(10, a3.width)
        XCTAssertEqual(7, a3.height)
        
        let a4_e = "" +
        "     .    \n" +
        "   . J    \n" +
        "   A E    \n" +
        ".HAzElNUT.\n" +
        "   U L    \n" +
        ".MErRy.   \n" +
        "   E .    \n" +
        "   .      "
        XCTAssertEqual(a4_e.uppercased(), a4.text)
        XCTAssertEqual(148, a4.score)
        XCTAssertEqual(10, a4.width)
        XCTAssertEqual(8, a4.height)
        
        let a5_e = "" +
        "   .      \n" +
        " . A      \n" +
        ".hAzELNUT.\n" +
        " Y U      \n" +
        ".mErRY.   \n" +
        " N E      \n" +
        " . .      "
        XCTAssertEqual(a5_e.uppercased(), a5.text)
        XCTAssertEqual(124, a5.score)
        XCTAssertEqual(10, a5.width)
        XCTAssertEqual(7, a5.height)
        
        let a6_e = "" +
        "      . \n" +
        "      H \n" +
        ".TURKEy.\n" +
        "      M \n" +
        "      N \n" +
        "      . "
        XCTAssertEqual(a6_e.uppercased(), a6.text)
        XCTAssertEqual(52, a6.score)
        XCTAssertEqual(8, a6.width)
        XCTAssertEqual(6, a6.height)
        
        let a7_e = "" +
        "  .     \n" +
        "  S     \n" +
        "  A     \n" +
        ".TuRKEY.\n" +
        "  C     \n" +
        "  E     \n" +
        "  .     "
        XCTAssertEqual(a7_e.uppercased(), a7.text)
        XCTAssertEqual(36, a7.score)
        XCTAssertEqual(8, a7.width)
        XCTAssertEqual(7, a7.height)
        
        let a8_e = "" +
        " .  . \n" +
        ".tOYs.\n" +
        " O  A \n" +
        " A  U \n" +
        " S  C \n" +
        ".tREe.\n" +
        " .  . "
        XCTAssertEqual(a8_e.uppercased(), a8.text)
        XCTAssertEqual(90, a8.score)
        XCTAssertEqual(6, a8.width)
        XCTAssertEqual(7, a8.height)
        
        let a9_e = "" +
        "   .  \n" +
        "   F  \n" +
        "   A  \n" +
        "   M  \n" +
        "   I  \n" +
        "   L  \n" +
        ".TOyS.\n" +
        "   .  "
        XCTAssertEqual(a9_e.uppercased(), a9.text)
        XCTAssertEqual(52, a9.score)
        XCTAssertEqual(6, a9.width)
        XCTAssertEqual(8, a9.height)
        
        let a10_e = "" +
        "   . \n" +
        "   H \n" +
        "   Y \n" +
        "   M \n" +
        ".INn.\n" +
        "   . "
        XCTAssertEqual(a10_e.uppercased(), a10.text)
        XCTAssertEqual(28, a10.score)
        XCTAssertEqual(5, a10.width)
        XCTAssertEqual(6, a10.height)
        
        let a11_e = "" +
        "    .   \n" +
        "    P   \n" +
        "    O   \n" +
        "    R   \n" +
        ".TURkEY.\n" +
        "    .   "
        XCTAssertEqual(a11_e.uppercased(), a11.text)
        XCTAssertEqual(24, a11.score)
        XCTAssertEqual(8, a11.width)
        XCTAssertEqual(6, a11.height)
        
        let a12_e = "" +
        "   .   \n" +
        "   F   \n" +
        "   A   \n" +
        "   M   \n" +
        ".WHiTE.\n" +
        "   L   \n" +
        "   Y   \n" +
        "   .   "
        XCTAssertEqual(a12_e.uppercased(), a12.text)
        XCTAssertEqual(24, a12.score)
        XCTAssertEqual(7, a12.width)
        XCTAssertEqual(8, a12.height)
        
        let a13_e = "" +
        " .     \n" +
        " S     \n" +
        " N     \n" +
        " O     \n" +
        ".wHITE.\n" +
        " .     "
        XCTAssertEqual(a13_e.uppercased(), a13.text)
        XCTAssertEqual(36, a13.score)
        XCTAssertEqual(7, a13.width)
        XCTAssertEqual(6, a13.height)
        
        let a14_e = "" +
        "     . \n" +
        "     C \n" +
        "     A \n" +
        "     K \n" +
        ".WHITe.\n" +
        "     . "
        XCTAssertEqual(a14_e.uppercased(), a14.text)
        XCTAssertEqual(22, a14.score)
        XCTAssertEqual(7, a14.width)
        XCTAssertEqual(6, a14.height)
        
    }
}
