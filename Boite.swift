// ====================================================
//
//  Boite.swift
//  TIM.Café
//
//  Created by Alain on 17-03-09.
//  Copyright © 2017 Alain. All rights reserved.
//
// ====================================================
// Branche m-a-j-Boite
// Ajout de fonctionnalités de positionnement dans la boite
import Foundation
/*
 ┌─────────┐
 │  titre  │
 ╞═════════╡
 │ contenu │
 └─────────┘
 */

enum ANSIColors: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[1;31m"
    case green = "\u{001B}[1;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case cls   = "\u{001B}[2J"
}

// Note: valeur par défaut d'un param ne peut pas être une propriété de la classe
let largeurParDéfaut = 35

// =====================================================
/// <#Description#>
class Boite {
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
    // FIN =================================================


    // =====================================================
    /// <#Description#>
    ///
    /// - Author: Alain Boudreault
    /// - Parameters:
    ///   - titre: <#titre description#>
    ///   - couleur: <#couleur description#>
    ///   - gras: <#gras description#>
    ///   - longueur: <#longueur description#>
    static func entete(_ titre: String, couleur: String = "", gras:Bool = false, longueur:Int = largeurParDéfaut) {
        
        tracerLigne(longueur: longueur, position: .haut)
        afficher(titre, centré: true)
        tracerLigne(longueur: longueur, position: .basEntête)
        
    } // entete
    // FIN =================================================
    
    
    // =====================================================
    /// <#Description#>
    ///
    /// - haut: <#haut description#>
    /// - bas: <#bas description#>
    /// - basEntête: <#basEntête description#>
    /// - séparateur: <#séparateur description#>
    enum PositionLigne{
        case haut, bas, basEntête, séparateur
    } // PositionLigne
    // FIN =================================================
    
    // =====================================================
     /// <#Description#>
     /// - Author:
     ///
     /// - Parameters:
     ///   - longueur: <#longueur description#>
     ///   - position: <#position description#>
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
    } // tracerLigne
    // FIN =================================================

    static func cls() {
        print(ANSIColors.cls.rawValue)
        gotoXY(0,0)
    } // cls
    
    static func pause(_ msg:String = "") -> String {
        print(msg, separator:"")
        return readLine()!
    } // pause
    
    static func gotoXY(_ x:Int, _ y:Int) {
        print("\u{001B}[\(y);\(x)H")
    } // gotoXY
    
    
    // =====================================================
    /// Affiche une chaine de caractères, dans une couleur donnée, avec délimiteurs de boite
    ///
    /// - Author: Alain Boudreault
    /// - Parameters:
    ///   - chaines: <#chaines description#>
    ///   - couleur: <#couleur description#>
    ///   - gras: <#gras description#>
    ///   - centré: <#centré description#>
    ///   - longueur: <#longueur description#>
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
    // FIN =================================================

    
    /// Affiche une chaine de caractères, dans une couleur donnée, sans délimiteurs de boite
    ///
    /// - Parameters:
    ///   - texte: Un texte à afficher
    ///   - couleur: Une séquence couleur ANSI, utilisée pour afficher le texte
    static func printCouleur(_ texte:String, _ couleur:ANSIColors) {
        print(couleur.rawValue, texte, ANSIColors.black.rawValue)
    } // printCouleur

} // Boite
// FIN =================================================
