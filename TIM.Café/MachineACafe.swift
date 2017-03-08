//
//  MachineACafe.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

enum TypesCafé:String {
    case espresso
    case latte
    case cappuccino
    case ristretto
    case mocha
}

enum ErreursDeLaMachineÀCafé: Error {
    case plusDeCafé
    case plusDeGoblet
    case plusDeSucre
    case plusDeCrème
    case plusDeChange
    case plusAccèsÀUneSourceDEau
}

class MachineÀCafé  {
    var inventaireCafé:Int
    var inventaireGoblet:Int
    var inventaireSucre:Int
    var inventaireCrème:Int
    var accèsÀUneSourceDEau = true
    var changeDisponible    = 5
    var ventesTotales:Float = 0.0
    let coutDuCafé:Float
    
    init(
         quantCafé:Int,
         quantGloblet:Int,
         quantSucre:Int,
         quantCrème:Int,
         coutDuCafé:Float){
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
                  coutDuCafé:   1.99)
    }  // convenience init()

    deinit {
        print("La machine à café a fait des ventes de \(ventesTotales)")
    }

    func fabriquerUnCafé(typeCafé:TypesCafé, crème:Int, sucre:Int, extraFort:Bool = false) throws{
    
        guard inventaireCafé > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeCafé
        }

        guard inventaireGoblet > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeGoblet
        }

        // un nombre entre 0 et 9
        guard arc4random_uniform(10) < 9 else {
           throw ErreursDeLaMachineÀCafé.plusAccèsÀUneSourceDEau
        }
        
        inventaireCafé -= 1
        inventaireGoblet -= 1
        
        ventesTotales += coutDuCafé
        print("Un café \(typeCafé) est servi")
        
    } // fabriquerUnCafé
    
    func obtenirInventaire() -> (café:Int, goblet:Int, sucre:Int, crème:Int,vente:Float ){
        return (inventaireCafé,
            inventaireGoblet,
            inventaireSucre,
            inventaireCrème,
            ventesTotales)
    }
} // MachineÀCafé
