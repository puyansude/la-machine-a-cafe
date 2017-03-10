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

// Note: valeur par défaut d'un param ne peut pas être une propriété de la classe
let largeurParDéfaut = 35

class Boite {

    private func ab(_ a:String, b: Int) {
        print("ab")
    }
    
    // http://www.duxburysystems.com/documentation/dbt11.1/miscellaneous/Special_Characters/Unicode_25xx.htm
    enum caractèresPourTracerLaBoite: String {
     case horizontal            = "─"
     case horizontalPiedEntete  = "═"
     case vertical              = "│"
     case coinHautGauche        = "┌"
     case coinHautDroit         = "┐"
     case coinEnteteBasGauche   = "╞"
     case coinEnteteBasDroit    = "╡"
     case coinBasGauche         = "└"
     case coinBasDroit          = "┘"
     case séparateurGauche      = "├"
     case séparateurDroit       = "┤"
        
    } // enum caractèresPourTracerLaBoite


    static func entete(_ titre: String, couleur: String = "", gras:Bool = false, longueur:Int = largeurParDéfaut) {
        
        tracerLigne(longueur: longueur, position: .haut)
        afficher(titre, centré: true)
        tracerLigne(longueur: longueur, position: .basEntête)
        
    } // entete
    
    enum PositionLigne{
        case haut, bas, basEntête, séparateur
    }
    
     static func tracerLigne(longueur:Int = largeurParDéfaut, position: PositionLigne) {
        var coinGauche:String
        var coinDroit:String
        var carHorizontal = caractèresPourTracerLaBoite.horizontal.rawValue
        
        switch position {
        case .bas:
             coinGauche = caractèresPourTracerLaBoite.coinBasGauche.rawValue
             coinDroit = caractèresPourTracerLaBoite.coinBasDroit.rawValue
        case .haut:
            coinGauche = caractèresPourTracerLaBoite.coinHautGauche.rawValue
            coinDroit = caractèresPourTracerLaBoite.coinHautDroit.rawValue

        case .basEntête:
            coinGauche = caractèresPourTracerLaBoite.coinEnteteBasGauche.rawValue
            coinDroit = caractèresPourTracerLaBoite.coinEnteteBasDroit.rawValue
            carHorizontal = caractèresPourTracerLaBoite.horizontalPiedEntete.rawValue
            
        case .séparateur:
            coinGauche = caractèresPourTracerLaBoite.séparateurGauche.rawValue
            coinDroit = caractèresPourTracerLaBoite.séparateurDroit.rawValue

        } // switch positionLigne

        var ligne = coinGauche
        ligne += carHorizontal.répéter(longueur - 2)
        
        print(ligne + coinDroit)
        
    }


    static func afficher( _ chaines: String ... , couleur: String = "", gras:Bool = false, centré:Bool = false, longueur:Int = largeurParDéfaut) {
    
        var lesChaines = ""
        var concaténation = caractèresPourTracerLaBoite.vertical.rawValue
        
        //
        for chaine in chaines {
            lesChaines += chaine
        }

        // Si centré alors insérer des espaces à gauche
        concaténation += centré == true ? " ".répéter( (longueur - lesChaines.characters.count - 1) / 2) : ""

        concaténation += lesChaines

        // compléter avec des espaces pour obtenir une chaine de 'longueur'
        concaténation += " ".répéter(longueur - concaténation.characters.count - 1)
        concaténation += caractèresPourTracerLaBoite.vertical.rawValue
        print (concaténation)
    } // afficher
    

} // Boite
