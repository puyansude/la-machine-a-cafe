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

enum ANSIColors: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[1;31m"
    case green = "\u{001B}[1;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
}

let black = "\u{001B}[0;30m"
let red = "\u{001B}[1;31m"
let green = "\u{001B}[0;32m"

func printCouleur(_ texte:String, _ couleur:ANSIColors) {
    print(couleur.rawValue, texte, ANSIColors.black.rawValue)

}
