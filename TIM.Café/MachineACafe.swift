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
//  paramètre par défaut, 
//  passer une fonction en paramètre, ...
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
    // Accessoires de la machine à café
    static let goblet      = RecettesCafé(rawValue: 1 << 8) // 100000000  256
    static let couvercle   = RecettesCafé(rawValue: 1 << 9) // 100000000  256
    static let change      = RecettesCafé(rawValue: 1 << 10)
    
    // Recettes
    static let caféMaison:RecettesCafé  = [.goblet, .couvercle, .café, .sucre, .crème]
    static let espresso:RecettesCafé    = [.goblet, .café]
    static let cappuccino:RecettesCafé  = [.goblet, .doubleCafé, .doubleCrème, .cannelle]
    static let latte:RecettesCafé       = [.goblet, .café, .doubleCrème]
    static let affogato:RecettesCafé    = [.goblet, .couvercle, .doubleCafé, .sucre, .doubleCrème, .vanille]
    static let mocha:RecettesCafé       = [goblet, café, doubleCrème, doubleSucre] // valide sans le . mais pas d'aide de Xcode pour proposer des choix possibles.
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

    var inventaireMachineCafé:Dictionary<Int, Int> = [
        RecettesCafé.café.rawValue:0,
        RecettesCafé.sucre.rawValue:0,
        RecettesCafé.crème.rawValue:0,
        RecettesCafé.cannelle.rawValue:0,
        RecettesCafé.vanille.rawValue:0,
        RecettesCafé.goblet.rawValue:0,
        RecettesCafé.couvercle.rawValue:0,
        RecettesCafé.change.rawValue:0
    ]
    
    var accèsÀUneSourceDEau = true
    var changeDisponible    = 5
    var ventesTotales:Float = 0.0
    let coutDuCafé:Float
    var delegate:MachineÀCaféDelegate?

    // lazy = créer l'instance seulement à la première utilisation
    lazy var numberFormatter = NumberFormatter()

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
        
        inventaireMachineCafé[RecettesCafé.café.rawValue]! = quantCafé
        inventaireMachineCafé[RecettesCafé.crème.rawValue]! = quantCrème
        inventaireMachineCafé[RecettesCafé.sucre.rawValue]! = quantSucre
        inventaireMachineCafé[RecettesCafé.cannelle.rawValue]! = quantCannelle
        inventaireMachineCafé[RecettesCafé.vanille.rawValue]! = quantVanille
        inventaireMachineCafé[RecettesCafé.goblet.rawValue]! = quantGloblet
        inventaireMachineCafé[RecettesCafé.couvercle.rawValue]! = 10
        inventaireMachineCafé[RecettesCafé.change.rawValue]! = 10

        self.coutDuCafé         = coutDuCafé

        /*
        self.inventaireCafé     = quantCafé
        self.inventaireCrème    = quantCrème
        self.inventaireGoblet   = quantGloblet
        self.inventaireSucre    = quantSucre
        self.inventaireCannelle = quantCannelle
        self.inventaireVanille  = quantVanille

         */
        
    } // init
    
    // Un constructeur de convenance pour le programmeur paresseux.
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
        
        guard inventaireMachineCafé[RecettesCafé.café.rawValue]! > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeCafé
        }

        guard inventaireMachineCafé[RecettesCafé.goblet.rawValue]! > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeGoblet
        }

        // un nombre entre 0 et 9
        if arc4random_uniform(10) >= 9 {
            delegate?.plusAccesADeLeau(sender:self)
            return
           // throw ErreursDeLaMachineÀCafé.plusAccèsÀUneSourceDEau
        }
        
        inventaireMachineCafé[RecettesCafé.café.rawValue]!      -= 1
        inventaireMachineCafé[RecettesCafé.goblet.rawValue]!    -= 1
        
        ventesTotales += coutDuCafé
        print("---> Un \(obtenirNomCafé(unCafé)) est servi...")
        
    } // fabriquerUnCafé
    
    // Les méthodes de traitements de l'inventaire:
    // ********************************************
    func traiterInventaire( opération: ( _ :RecettesCafé, _ :Int) -> Bool, ingrédient:RecettesCafé, quantité:Int) -> Bool {
        return opération(ingrédient, quantité)
    } // traiterInventaire
    
    func ajouter( ingrédient :RecettesCafé, quantité :Int) -> Bool  {
        print("Inventaire: ajouter")
        return true
    } // ajouter

    func retirer( ingrédient :RecettesCafé, quantité :Int) -> Bool  {
        print("Inventaire: retirer")
        return true
    }  // retirer

    func disponibilité( ingrédient :RecettesCafé, quantité :Int) -> Bool  {
        print("Inventaire: disponibilité")
        return true
    } // disponibilité
    // ********************************************

    
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
        
        print("Ingrédients requis pour fabriquer le café:\n -->totalCafé: \(totalCafé), totalSucre: \(totalSucre), totalCrème: \(totalCrème), totalCannelle: \(totalCannelle), totalVanille: \(totalVanille)")
        
        _ = traiterInventaire(opération: disponibilité, ingrédient: RecettesCafé.café, quantité: 1)
        
    }
    
    func obtenirInventaire() -> (café:Int, goblet:Int, sucre:Int, crème:Int,vente:Float ){
        return (inventaireMachineCafé[RecettesCafé.café.rawValue]!,
            inventaireMachineCafé[RecettesCafé.goblet.rawValue]!,
            inventaireMachineCafé[RecettesCafé.sucre.rawValue]!,
            inventaireMachineCafé[RecettesCafé.crème.rawValue]!,
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
