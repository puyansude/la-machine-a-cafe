//
//  MachineACafe.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

struct RecettesCafé : OptionSet {
    let rawValue: Int
    // Ingrédients
    static let café        = RecettesCafé(rawValue: 1 << 0) // 00000001  1
    static let crème       = RecettesCafé(rawValue: 1 << 1) // 00000010  2
    static let doubleCrème = RecettesCafé(rawValue: 1 << 2) // 00000101  4
    static let sucre       = RecettesCafé(rawValue: 1 << 3) // 00001000  8
    static let doubleSucre = RecettesCafé(rawValue: 1 << 4) // 00010000  16
    static let doubleCafé  = RecettesCafé(rawValue: 1 << 5) // 00100000  32
    static let cannelle    = RecettesCafé(rawValue: 1 << 6) // 01000000  64
    
    // Recettes
    static let caféBase:RecettesCafé = [.café, .sucre, .crème]
    static let espresso:RecettesCafé = [.doubleCafé]
    static let cappuccino:RecettesCafé = [.doubleCafé, .doubleCrème, .cannelle]
    static let latte:RecettesCafé = [.café, .doubleCrème]
    static let ristretto:RecettesCafé = [.doubleCafé, .doubleSucre]
    static let mocha:RecettesCafé = [.café, .doubleCrème, .doubleSucre]
}


// Énumération des types de café
enum TypesCafé:String {
    case café
    case espresso
    case latte
    case cappuccino
    case ristretto
    case mocha
}

// Énumération des erreurs de la machine à café
enum ErreursDeLaMachineÀCafé: Error {
    case plusDeCafé
    case plusDeGoblet
    case plusDeSucre
    case plusDeCrème
    case plusDeChange
    case plusAccèsÀUneSourceDEau
}

/* @objc */
protocol MachineÀCaféDelegate {
     /* @objc optional */
    func plusAccesADeLeau(sender:MachineÀCafé)
}

//
class MachineÀCafé {
    var inventaireCafé:Int
    var inventaireGoblet:Int
    var inventaireSucre:Int
    var inventaireCrème:Int
    var accèsÀUneSourceDEau = true
    var changeDisponible    = 5
    var ventesTotales:Float = 0.0
    let coutDuCafé:Float
    var delegate:MachineÀCaféDelegate?

    // Le constructeur
    init(
         quantCafé:Int,
         quantGloblet:Int,
         quantSucre:Int,
         quantCrème:Int,
         coutDuCafé:Float){
        print(ANSIColors.green.rawValue, "### Je suis le constructeur de la classe 'MachineÀCafé' ###\n", ANSIColors.black.rawValue)
        self.inventaireCafé     = quantCafé
        self.inventaireCrème    = quantCrème
        self.inventaireGoblet   = quantGloblet
        self.inventaireSucre    = quantSucre
        self.coutDuCafé         = coutDuCafé

    } // init
    
    convenience init() {
        self.init(quantCafé:    12,
                  quantGloblet: 12,
                  quantSucre:   6,
                  quantCrème:   6,
                  coutDuCafé:   2.25)
    }  // convenience init()

    // Le destructeur
    deinit {
        print(ANSIColors.red.rawValue,"\n*** Je suis le destructeur de la classe: 'MachineÀCafé' ***", ANSIColors.black.rawValue)
        print("\t--> La machine à café a fait des ventes de \(ventesTotales) $")
    } // deinit

    // Les méthodes de classe
    static func quiSuisJe() -> String {
        return "Je suis une machine à café virtuelle"
    }
    
    // Les méthodes d'instance
    func fabriquerUnCafé(typeCafé:TypesCafé, crème:Int, sucre:Int, extraFort:Bool = false) throws{
    
        guard inventaireCafé > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeCafé
        }

        guard inventaireGoblet > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeGoblet
        }

        // un nombre entre 0 et 9
        if arc4random_uniform(10) >= 9 {
            delegate?.plusAccesADeLeau(sender:self)
            return
           // throw ErreursDeLaMachineÀCafé.plusAccèsÀUneSourceDEau
        }
        
        inventaireCafé -= 1
        inventaireGoblet -= 1
        
        ventesTotales += coutDuCafé
        print("---> Un \(typeCafé) est servi...")
        
    } // fabriquerUnCafé
    
    func obtenirInventaire() -> (café:Int, goblet:Int, sucre:Int, crème:Int,vente:Float ){
        return (inventaireCafé,
            inventaireGoblet,
            inventaireSucre,
            inventaireCrème,
            ventesTotales)
    }
    
    func texteInventaire() -> String{
        
        let inventaire = self.obtenirInventaire()
        // http://www.duxburysystems.com/documentation/dbt11.1/miscellaneous/Special_Characters/Unicode_25xx.htm

        var texteInventaire = "\n*********************************"
        texteInventaire    += "\nInventaire de la machine à café:\n"
        texteInventaire    += "*********************************"
        texteInventaire    += "\n Café:   \(inventaire.café)"
        texteInventaire    += "\n Goblet: \(inventaire.goblet)"
        texteInventaire    += "\n Sucre:  \(inventaire.sucre)"
        texteInventaire    += "\n Crème:  \(inventaire.crème)"
        texteInventaire    += "\n Vente:  \(String(format: "%2.2f $" , inventaire.vente))\n"
        texteInventaire    += "*********************************\n"
        return texteInventaire
    } // FormaterInventaire

} // MachineÀCafé
