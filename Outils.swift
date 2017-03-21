//
//  Outils.swift
//  TIM.Café
//
//  Created by Alain on 17-03-08.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

extension String {
    func répéter(_ fois:Int) -> String {
        return String(repeating: self, count: fois)
    } // répéter
    
    func pad(with character: String, toLength length: Int) -> String {
        let padCount = length - self.characters.count
        guard padCount > 0 else { return self }
        return String(repeating: character, count: padCount) + self
    }
} // extension String

let longueurChaineBinaire = 12
extension Int {
    func toBin(_ longueur:Int = longueurChaineBinaire)->String {
        return "0b" + String(self, radix: 2)
    } // toBin

    func toBinWithPad(_ longueur:Int = longueurChaineBinaire)->String {
        return "0b" + String(self, radix: 2).pad(with: "0", toLength: longueur)
    } // toBinWithPad
} //extension Int

// Disable print for production.
func printDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}
