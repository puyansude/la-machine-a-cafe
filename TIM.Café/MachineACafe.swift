//
//  MachineACafe.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//  -----------------------------------------------------
//  Description
//
//  Une symphatique machine à café virtuelle permettant
//  d'expérimenter avec les concepts suivants de swift:
//
//  class, extension, enum, struct, OptionSet, rawValue
//  init, deinit, convenience init,
//  do/try/catch/error, try?, guard, break
//  protocol, delegate, CustomStringConvertible, Hashable
//  lazy, n-tuplet, fonction variadique,
//  paramètre par défaut,
//  passer une fonction en paramètre, ...
//  -----------------------------------------------------


import Foundation

struct RecettesCafé : OptionSet, Hashable, CustomStringConvertible {
    
    // Implémentation du protocole OptionSet: donne accès à des fn de la théorie des ensembles: test, union, intersection, ...
    let rawValue: Int
    
    // Implémentation du protocole Hashable -> programmer un getter pour 'hashValue'
    // La variable 'hashValue' sera utilisée dans un contexte d'indice.
    // Par exemple, au lieu de unTableau[RecettesCafé.crème.rawValue] il sera
    // possible d'utiliser la forme unTableau[RecettesCafé.crème]
    // https://fr.wikipedia.org/wiki/Fonction_de_hachage
    var hashValue: Int {
        return self.rawValue
    }
    
    // Ingrédients
    static let café        = RecettesCafé(rawValue: 1 << 0) // 00000001  1
    static let crème       = RecettesCafé(rawValue: 1 << 1) // 00000010  2
    static let doubleCrème = RecettesCafé(rawValue: 1 << 2) // 00000100  4
    static let sucre       = RecettesCafé(rawValue: 1 << 3) // 00001000  8
    static let doubleSucre = RecettesCafé(rawValue: 1 << 4) // 00010000  16
    static let doubleCafé  = RecettesCafé(rawValue: 1 << 5) // 00100000  32
    static let cannelle    = RecettesCafé(rawValue: 1 << 6) // 01000000  64
    static let vanille     = RecettesCafé(rawValue: 1 << 7) // 10000000  128
    // Accessoires de la machine à café
    static let goblet      = RecettesCafé(rawValue: 1 << 8) //100000000  256
    static let couvercle   = RecettesCafé(rawValue: 1 << 9)
    //static let change      = RecettesCafé(rawValue: 1 << 10)
    
    // Recettes
    static let caféMaison:RecettesCafé  = [.goblet, .couvercle, .café, .sucre, .crème]
    static let espresso:RecettesCafé    = [.goblet, .café]
    static let cappuccino:RecettesCafé  = [.goblet, .doubleCafé, .doubleCrème, .cannelle]
    static let latte:RecettesCafé       = [.goblet, .café, .doubleCrème]
    static let affogato:RecettesCafé    = [.goblet, .couvercle, .doubleCafé, .sucre, .doubleCrème, .vanille]
    static let mocha:RecettesCafé       = [goblet, café, doubleCrème, doubleSucre] // valide sans le . mais pas d'aide de Xcode pour proposer des choix possibles.
    
    var description:String {
        switch self {
            case RecettesCafé.café: return "café"
            case RecettesCafé.sucre: return "sucre"
            case RecettesCafé.crème: return "crème"
            case RecettesCafé.cannelle: return "cannelle"
            case RecettesCafé.vanille: return "vanille"
            case RecettesCafé.caféMaison: return "café maison"
            case RecettesCafé.espresso: return "espresso"
            case RecettesCafé.cappuccino: return "cappuccino"
            case RecettesCafé.latte: return "latte"
            case RecettesCafé.affogato: return "affogato"
            case RecettesCafé.mocha: return "mocha"
            
            default: return "Ingrédient non défini"
        } // switch self
    } // var description
    
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
// final class = pas possible de créer de nouvelles classes à partir de celle-ci.
final class MachineÀCafé {
    
    var inventaireMachineCafé:Dictionary<RecettesCafé, Int> = [
        .café       : 0,  // RecettesCafé sous entendu pas inférence
        .sucre      : 0,
        .crème      : 0,
        .cannelle   : 0,
        .vanille    : 0,
        .goblet     : 0,
        .couvercle  : 0,
        //.change     : 0
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
        quantCafé:     Int,
        quantGloblet:  Int,
        quantSucre:    Int,
        quantCrème:    Int,
        quantCannelle: Int,
        quantVanille:  Int,
        coutDuCafé:    Float){
        printCouleur("### Je suis le constructeur de la classe 'MachineÀCafé' ###\n", .green)
        
        // Il est possible d'indicer le dictionnaire avec RecettesCafé parce que RecettesCafé est conforme au protocole 'Hashable'
        inventaireMachineCafé[.café]!       = quantCafé
        inventaireMachineCafé[.crème]!      = quantCrème
        inventaireMachineCafé[.sucre]!      = quantSucre
        inventaireMachineCafé[.cannelle]!   = quantCannelle
        inventaireMachineCafé[.vanille]!    = quantVanille
        inventaireMachineCafé[.goblet]!     = quantGloblet
        inventaireMachineCafé[.couvercle]!  = 10
        //inventaireMachineCafé[.change]!     = 10
        self.coutDuCafé                     = coutDuCafé
        
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
    func infuser(_ unCafé:RecettesCafé, crème:Int = 0, sucre:Int = 0, extraFort:Bool = false) throws {
        
        MAJInventaire(café:unCafé)
        
        guard inventaireMachineCafé[RecettesCafé.café]! > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeCafé
        }
        
        guard inventaireMachineCafé[RecettesCafé.goblet]! > 0 else {
            throw ErreursDeLaMachineÀCafé.plusDeGoblet
        }
        
        // un nombre entre 0 et 9
        if arc4random_uniform(10) >= 9 {
            delegate?.plusAccesADeLeau(sender:self)
            return
            // throw ErreursDeLaMachineÀCafé.plusAccèsÀUneSourceDEau
        }
        
        inventaireMachineCafé[.café]!      -= 1
        inventaireMachineCafé[.goblet]!    -= 1
        
        ventesTotales += coutDuCafé
        print("---> Un \(unCafé) est servi...")
        
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
        let ingrédientDisponible = inventaireMachineCafé[ingrédient]! >= quantité ? true : false
        print("\(quantité) \(ingrédient) disponibilité: \(ingrédientDisponible)")
        
        return ingrédientDisponible
    } // disponibilité
    // ********************************************
    
    
    private func MAJInventaire(café:RecettesCafé) /* throws */
    {
        var totalSucre      = 0
        var totalCafé       = 0
        var totalCrème      = 0
        var totalCannelle   = 0
        var totalVanille    = 0

        // Helper fn
        func dispo(_ ingrédient: RecettesCafé, _ quantité: Int) -> Bool {
            return traiterInventaire(opération: disponibilité, ingrédient: ingrédient, quantité: quantité)
        }

        print("Ingrédients requis pour fabriquer le café:\n")
        if café.contains(.café)         { _=dispo(.café, 1); totalCafé += 1}
        if café.contains(.sucre)        { _=dispo(.sucre, 1);totalSucre += 1 }
        if café.contains(.crème)        { _=dispo(.crème, 1);totalCrème += 1 }
        if café.contains(.doubleCafé)   { _=dispo(.café, 2);totalCafé += 2 }
        if café.contains(.doubleSucre)  { _=dispo(.sucre, 2);totalSucre += 2 }
        if café.contains(.doubleCrème)  { _=dispo(.crème, 2);totalCrème += 2 }
        if café.contains(.cannelle)     { _=dispo(.cannelle, 1);totalCannelle += 1 }
        if café.contains(.vanille )     { _=dispo(.vanille, 1);totalVanille += 1 }


    } // MAJInventaire
    
    
    
    // Note: Utilisation de n-tuples pour le retour des valeurs
    func obtenirInventaire() -> (café:Int, goblet:Int, sucre:Int, crème:Int,vente:Float ){
        return (inventaireMachineCafé[.café]!,
                inventaireMachineCafé[.goblet]!,
                inventaireMachineCafé[.sucre]!,
                inventaireMachineCafé[.crème]!,
                ventesTotales)
    } // obtenirInventaire()
    
    
} // MachineÀCafé

// Ajout de fonctionnalités è la classe 'MachineÀCafé'
extension MachineÀCafé: CustomStringConvertible {
    // Implémentation du protocole CustomStringConvertible
    var description: String {
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
