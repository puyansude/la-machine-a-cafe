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

enum IngrédientsRawValue: Int {
    case café         =  0b0000000001
    case crème        =  0b0000000010
    case doubleCrème  =  0b0000000100
    case sucre        =  0b0000001000
    case doubleSucre  =  0b0000010000
    case doubleCafé   =  0b0000100000
    case cannelle     =  0b0001000000
    case vanille      =  0b0010000000
    case goblet       =  0b0100000000
    case couvercle    =  0b1000000000

    var valeur: Int {
        return self.rawValue
    }

} // IngrédientsRawValue

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
    static let café        = RecettesCafé(rawValue: IngrédientsRawValue.café.valeur)
    static let crème       = RecettesCafé(rawValue: IngrédientsRawValue.crème.valeur)
    static let doubleCrème = RecettesCafé(rawValue: IngrédientsRawValue.doubleCrème.valeur)
    static let sucre       = RecettesCafé(rawValue: IngrédientsRawValue.sucre.valeur)
    static let doubleSucre = RecettesCafé(rawValue: IngrédientsRawValue.doubleSucre.valeur)
    static let doubleCafé  = RecettesCafé(rawValue: IngrédientsRawValue.doubleCafé.valeur)
    static let cannelle    = RecettesCafé(rawValue: IngrédientsRawValue.cannelle.valeur)
    static let vanille     = RecettesCafé(rawValue: IngrédientsRawValue.vanille.valeur)
    // Accessoires de la machine à café
    static let goblet      = RecettesCafé(rawValue: IngrédientsRawValue.goblet.valeur)
    static let couvercle   = RecettesCafé(rawValue: IngrédientsRawValue.couvercle.valeur)
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
        case RecettesCafé.goblet: return "goblet"
        case RecettesCafé.couvercle: return "couvercle"
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
} // struct RecettesCafé



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
    case plusDeCannelle
    case plusDeVanille
    case plusDeCouvercle
    case plusAccèsÀUneSourceDEau
    case impossibleDeLireInventaire
    case inventaireInsuffisant
    case impossibleAjouterInventaire
    case impossibleModifierInventaire
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
    /// <#Description#>
    var delegate:MachineÀCaféDelegate?
    
    // lazy = créer l'instance seulement à la première utilisation
    lazy var numberFormatter = NumberFormatter()
    
    // Le constructeur
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - quantCafé: <#quantCafé description#>
    ///   - quantGloblet: <#quantGloblet description#>
    ///   - quantSucre: <#quantSucre description#>
    ///   - quantCrème: <#quantCrème description#>
    ///   - quantCannelle: <#quantCannelle description#>
    ///   - quantVanille: <#quantVanille description#>
    ///   - coutDuCafé: <#coutDuCafé description#>
    init(
        quantCafé:     Int,
        quantGloblet:  Int,
        quantCouvercle:Int,
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
        inventaireMachineCafé[.couvercle]!  = quantCouvercle
        //inventaireMachineCafé[.change]!     = 10
        self.coutDuCafé                     = coutDuCafé
        
    } // init
    
    /// Un constructeur de convenance pour le programmeur paresseux.
    convenience init() {
        self.init(quantCafé:    4,
                  quantGloblet: 2,
                  quantCouvercle:1,
                  quantSucre:   4,
                  quantCrème:   4,
                  quantCannelle:1,
                  quantVanille: 1,
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
    
    // ====================================================
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - unCafé: <#unCafé description#>
    ///   - crème: <#crème description#>
    ///   - sucre: <#sucre description#>
    ///   - extraFort: <#extraFort description#>
    /// - Throws: <#throws value description#>
    func infuser(_ unCafé:RecettesCafé, crème:Int = 0, sucre:Int = 0, extraFort:Bool = false) throws {
        
        // Exception passée à 'infuser() throws'
        try traiterLesIngrédients(café:unCafé)
        
        // exception ne sera pas passé à 'infuser() throws'
        // do { try traiterLesIngrédients(café:unCafé) } catch { }
        
        // Générer, de façon aléatoire, un manque d'eau.
        if arc4random_uniform(10) >= 9 {
            delegate?.plusAccesADeLeau(sender:self)
            return
            // throw ErreursDeLaMachineÀCafé.plusAccèsÀUneSourceDEau
        }
        
        ventesTotales += coutDuCafé
        print("---> Un \(unCafé) est servi...")
        
    } // fabriquerUnCafé
    
    // ====================================================
    /**
     Les méthodes de traitements de l'inventaire:
     
     - author: Alain Boudreault
     - important:  Ce code n'est pas passé par le QA
     - version:    0.1
     - throws:     des fleurs.

     - parameter opération:  nom d'une méthode à exécuter
     - parameter ing: à passer à la méthode
     - parameter quant: à passer à la méthode
     - parameter ingrédient: ingrédient sur lequel appliquer la méthode
     - parameter quantité:   quantité servant à actualiser l'inventaire
     - returns:    true si l'opération a réussi sinon false
     - more:       rien à dire
     
     */

    // ====================================================
    /// <#Description#>
    ///
    /// - Parameters:    ///   - opération: <#opération description#>
    ///   - ingrédient: <#ingrédient description#>
    ///   - quantité: <#quantité description#>
    /// - Returns: <#return value description#>
    func traiterInventaire( opération: ( _ ing:RecettesCafé, _ quant:Int) throws -> Bool, ingrédient:RecettesCafé, quantité:Int) rethrows -> Bool {
        return try opération(ingrédient, quantité)
    } // traiterInventaire
    
    
    // ====================================================
    /// Permet d'ajouter une quantité à un ingrédient de la machine à café.
    ///
    /// - Parameters:
    ///   - ingrédient: <#ingrédient description#>
    ///   - quantité: <#quantité description#>
    /// - Returns: <#return value description#>
    func ajouter( ingrédient :RecettesCafé, quantité :Int) throws -> Bool  {
        print("Inventaire: ajouter")
        guard 1 == 2 else { throw ErreursDeLaMachineÀCafé.impossibleAjouterInventaire }
        return true
    } // ajouter
    
    
    // ====================================================
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - ingrédient: <#ingrédient description#>
    ///   - quantité: <#quantité description#>
    /// - Returns: <#return value description#>
    func retirer( ingrédient :RecettesCafé, quantité :Int) throws -> Bool  {
        print("Inventaire -> retirer: ", terminator: "")
        
        guard try disponibilité(ingrédient: ingrédient, quantité: quantité) else {

            switch ingrédient {
            
              case RecettesCafé.café : throw ErreursDeLaMachineÀCafé.plusDeCafé
              case RecettesCafé.crème : throw ErreursDeLaMachineÀCafé.plusDeCrème
              case RecettesCafé.sucre : throw ErreursDeLaMachineÀCafé.plusDeSucre
              case RecettesCafé.cannelle : throw ErreursDeLaMachineÀCafé.plusDeCannelle
              case RecettesCafé.vanille : throw ErreursDeLaMachineÀCafé.plusDeVanille
              case RecettesCafé.couvercle : throw ErreursDeLaMachineÀCafé.plusDeCouvercle
              case RecettesCafé.goblet : throw ErreursDeLaMachineÀCafé.plusDeGoblet
       
              default: throw ErreursDeLaMachineÀCafé.inventaireInsuffisant
            }
        } // guard disponibilité

        inventaireMachineCafé[ingrédient]! -= quantité
        
        return true
    }  // retirer
    
    // ====================================================
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - ingrédient: <#ingrédient description#>
    ///   - quantité: <#quantité description#>
    /// - Returns: <#return value description#>
    func disponibilité( ingrédient :RecettesCafé, quantité :Int) throws -> Bool  {
        let pluriel = quantité > 1 ?"s":""
        print("\(quantité) \(ingrédient)\(pluriel), disponibilité: [\(inventaireMachineCafé[ingrédient]!)]")
        return inventaireMachineCafé[ingrédient]! >= quantité ? true : false
            
    } // disponibilité
    // ********************************************

    
    // ====================================================
    /// <#Description#>
    ///
    /// - Parameter café: <#café description#>
    /// - Throws: <#throws value description#>
    private func traiterLesIngrédients(café:RecettesCafé) throws
    {
        print("Traitement des ingrédients requis pour fabriquer un [\(café)]\n")
        if café.contains(.café)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .café, quantité: 1)
        }

        if café.contains(.sucre)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .sucre, quantité: 1)
        }

        if café.contains(.doubleCafé)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .café, quantité: 2)
        }

        if café.contains(.doubleSucre)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .sucre, quantité: 2)
        }

        if café.contains(.doubleCrème)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .crème, quantité: 2)
        }

        if café.contains(.cannelle)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .cannelle, quantité: 1)
        }

        if café.contains(.vanille)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .vanille, quantité: 1)
        }

        if café.contains(.goblet)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .goblet, quantité: 1)
        }

        if café.contains(.couvercle)
        {
            try _ = traiterInventaire(opération: retirer, ingrédient: .couvercle, quantité: 1)
        }

        
    } // traiterLesIngrédients
    
    
    // ====================================================
    /**
     Une description pour aider le programmeur fatigué...
     
     - author: Alain Boudreault
     - important:  Ce code n'est pas passé par le QA
     - version:    1.0
     - throws:      des fleurs.
     
     - returns:     Utilisation de n-tuples pour le retour des valeurs.
     - more:        rien à dire
     
     */
    func obtenirInventaire() -> (café:Int, goblet:Int, sucre:Int, crème:Int,vente:Float ){
        return (inventaireMachineCafé[.café]!,
                inventaireMachineCafé[.goblet]!,
                inventaireMachineCafé[.sucre]!,
                inventaireMachineCafé[.crème]!,
                ventesTotales)
    } // obtenirInventaire()
    
    
} // MachineÀCafé

// Ajout de fonctionnalités à la classe 'MachineÀCafé'

// MARK: - <#CustomStringConvertible#>
// ====================================================
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
