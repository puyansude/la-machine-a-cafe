//
//  MachineACafe.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation


// Énumération des types de café
enum TypesCafé:String {
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
        self.init(quantCafé:    5,
                  quantGloblet: 4,
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
        print("---> Un café \(typeCafé) est servi...")
        
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
        var texteInventaire = "\n┌─────────────────────────────────┐"
        texteInventaire    += "\n│ Inventaire de la machine à café │"
        texteInventaire    += "\n└─────────────────────────────────┘"
        texteInventaire    += "\n\tCafé: \t\(inventaire.café)"
        texteInventaire    += "\n\tGoblet:\t\(inventaire.goblet)"
        texteInventaire    += "\n\tSucre:\t\(inventaire.sucre)"
        texteInventaire    += "\n\tCrème:\t\(inventaire.crème)"
        texteInventaire    += "\n\tVente:\t\(String(format: "%2.2f $" , inventaire.vente))"
        texteInventaire    += "\n ═════════════════════════════════"
        
        return texteInventaire
    } // FormaterInventaire

} // MachineÀCafé
