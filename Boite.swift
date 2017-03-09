//
//  Boite.swift
//  TIM.Café
//
//  Created by Alain on 17-03-09.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation
/*
 ┌─────────┐
 │  titre  │
 ╞═════════╡
 │ contenu │
 └─────────┘
 */

class Boite {

    private func ab(_ a:String, b: Int) {
        print("ab")
    }
    
    enum caractèresPourTracerLaBoite: String {
     case horizontal            = "─"
     case horizontalPiedEntete  = "═"
     case vertical              = "|"
     case coinHautGauche        = "┌"
     case coinHautDroit         = "┐"
     case coinEnteteBasGauche   = "╞"
     case coinEnteteBasDroit    = "╡"
     case coinBasGauche         = "└"
     case coinBasDroit          = "┘"
    }

    private func répéter(_ caractère:String, fois:Int) -> String {
        var chaine = ""
        for _ in 1...fois {
            chaine += caractère
        }
        return chaine
    } // répéter

    static func entete(_ titre: String, couleur: String = "", gras:Bool = false, longueur:Int = 40) {
        
        var ligne = caractèresPourTracerLaBoite.coinHautGauche.rawValue
        
        // Afficher la ligne du haut de l'entête
        //ligne += répéter(caractèresPourTracerLaBoite.horizontal.rawValue, fois: 10 )
        
        print(ligne + caractèresPourTracerLaBoite.coinHautDroit.rawValue)

        // Afficher le titre (centré) de l'entête
    } // entete
    
    
    static func afficher( _ chaines: String ... , couleur: String = "", gras:Bool = false, longueur:Int = 40) {
    
        var concaténation = "| "
        for chaine in chaines {
        
            concaténation += chaine
        }
    
        for _ in concaténation.characters.count ... longueur {
            concaténation += " "
        }
        
        concaténation += "|"
        
        print (concaténation)
    } // afficher
    
} // Boite
