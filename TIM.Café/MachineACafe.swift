//
//  MachineACafe.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//  -----------------------------------------------
//  Description
//
//  Une symphatique machine à café virtuelle permettant
//  d'expérimenter avec les concepts suivants de swift:
//
//  class, extension, enum, struct, OptionSet, rawValue
//  init, deinit, convenience init,
//  do/try/catch/error, try?, guard, break
//  protocol, delegate, CustomStringConvertible,
//  lazy, n-tuplet, fonction variadique, 
//  paramètre par défaut
//  -----------------------------------------------------


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
    static let vanille     = RecettesCafé(rawValue: 1 << 7) // 10000000  128
    
    // Recettes
    static let caféMaison:RecettesCafé = [.café, .sucre, .crème]
    static let espresso:RecettesCafé = [.café]
    static let cappuccino:RecettesCafé = [.doubleCafé, .doubleCrème, .cannelle]
    static let latte:RecettesCafé = [.café, .doubleCrème]
    static let affogato:RecettesCafé = [.doubleCafé, .sucre, .doubleCrème, .vanille]
    static let mocha:RecettesCafé = [.café, .doubleCrème, .doubleSucre]
}

// Énumération des types de café
enum TypesCafé:String {
    case café = "café maison"
    case espresso
    case latte
    case cappuccino
    case affogato
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
final class MachineÀCafé {
    var inventaireCafé:Int
    var inventaireGoblet:Int
    var inventaireSucre:Int
    var inventaireCrème:Int
    var inventaireCannelle:Int
    var inventaireVanille:Int
    
    var accèsÀUneSourceDEau = true
    var changeDisponible    = 5
    var ventesTotales:Float = 0.0
    let coutDuCafé:Float
    var delegate:MachineÀCaféDelegate?

    lazy var numberFormatter = NumberFormatter() // lazy = créer l'instance seulement à la première utilisation

    // Le constructeur
    init(
         quantCafé:Int,
         quantGloblet:Int,
         quantSucre:Int,
         quantCrème:Int,
         quantCannelle:Int,
         quantVanille:Int,
         coutDuCafé:Float){
        printCouleur("### Je suis le constructeur de la classe 'MachineÀCafé' ###\n", .green)
        self.inventaireCafé     = quantCafé
        self.inventaireCrème    = quantCrème
        self.inventaireGoblet   = quantGloblet
        self.inventaireSucre    = quantSucre
        self.inventaireCannelle = quantCannelle
        self.inventaireVanille  = quantVanille
        self.coutDuCafé         = coutDuCafé

    } // init
    
    convenience init() {
        self.init(quantCafé:    12,
                  quantGloblet: 12,
                  quantSucre:   6,
                  quantCrème:   6,
                  quantCannelle:6,
                  quantVanille: 4,
                  coutDuCafé:   2.25)
    }  // convenience init()

    // Le destructeur
    deinit {
        printCouleur("\n*** Je suis le destructeur de la classe: 'MachineÀCafé' ***", .red)
        print("\t--> La machine à café a fait des ventes de \(ventesTotales) $")
    } // deinit

    // Les méthodes de classe
    static func quiSuisJe() -> String {
        return "Je suis une machine à café virtuelle"
    }
    
    
    
    // Les méthodes d'instance
    private func obtenirNomCafé(_ typeCafé:RecettesCafé) -> String {
        
        var caféInfo:Dictionary<Int, TypesCafé> =
            [RecettesCafé.caféMaison.rawValue : TypesCafé.café,
             RecettesCafé.cappuccino.rawValue : TypesCafé.cappuccino,
             RecettesCafé.affogato.rawValue : TypesCafé.affogato,
             RecettesCafé.espresso.rawValue : TypesCafé.espresso,
             RecettesCafé.latte.rawValue : TypesCafé.latte,
             RecettesCafé.mocha.rawValue : TypesCafé.mocha,]
        
        guard let nomCafé = caféInfo[typeCafé.rawValue] else {return "Erreur typeCafé non défini"}
        return nomCafé.rawValue
    }

    
    func fabriquerUnCafé(_ unCafé:RecettesCafé, crème:Int = 0, sucre:Int = 0, extraFort:Bool = false) throws{
    
        MAJInventaire(café:unCafé)
        
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
        
        
        print("---> Un \(obtenirNomCafé(unCafé)) est servi...")
        
    } // fabriquerUnCafé
    
    
    private func MAJInventaire(café:RecettesCafé)
    {
        var totalSucre      = 0
        var totalCafé       = 0
        var totalCrème      = 0
        var totalCannelle   = 0
        var totalVanille    = 0
        
        if café.contains(.café)         { totalCafé     += 1 }
        if café.contains(.sucre)        { totalSucre    += 1 }
        if café.contains(.crème)        { totalCrème    += 1 }
        if café.contains(.doubleCafé)   { totalCafé     += 2 }
        if café.contains(.doubleSucre)  { totalSucre    += 2 }
        if café.contains(.doubleCrème)  { totalCrème    += 2 }
        if café.contains(.cannelle)     { totalCannelle += 1 }
        if café.contains(.vanille )     { totalVanille  += 1 }
        
        print("totalCafé: \(totalCafé), totalSucre: \(totalSucre), totalCrème: \(totalCrème), totalCannelle: \(totalCannelle), totalVanille: \(totalVanille)")
    }
    
    func obtenirInventaire() -> (café:Int, goblet:Int, sucre:Int, crème:Int,vente:Float ){
        return (inventaireCafé,
            inventaireGoblet,
            inventaireSucre,
            inventaireCrème,
            ventesTotales)
    }
    

} // MachineÀCafé

extension MachineÀCafé: CustomStringConvertible {
    // Implémentation du protocole CustomStringConvertible
    var description: String{
        numberFormatter.numberStyle = .currency
        
        let inventaire = self.obtenirInventaire()
        // http://www.duxburysystems.com/documentation/dbt11.1/miscellaneous/Special_Characters/Unicode_25xx.htm
        
        var texteInventaire = "\n*********************************"
        texteInventaire    += "\nInventaire de la machine à café:\n"
        texteInventaire    += "*********************************"
        texteInventaire    += "\n Café:   \(inventaire.café)"
        texteInventaire    += "\n Goblet: \(inventaire.goblet)"
        texteInventaire    += "\n Sucre:  \(inventaire.sucre)"
        texteInventaire    += "\n Crème:  \(inventaire.crème)"
        texteInventaire    += "\n Vente:  \(numberFormatter.string(from: NSNumber(value: inventaire.vente))!)\n" // String(format: "%2.2f $" , inventaire.vente)
        texteInventaire    += "*********************************\n"
        
        return texteInventaire
    } // FormaterInventaire
    
}
