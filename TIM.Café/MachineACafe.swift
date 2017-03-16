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


// ====================================================
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

// ====================================================
/* @objc */
protocol MachineÀCaféDelegate {
    /* @objc optional */
    func plusAccesADeLeau(sender:MachineÀCafé)
}

// ====================================================
// final class = pas possible de créer de nouvelles classes à partir de celle-ci.
final class MachineÀCafé {
    
    // ====================================================
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
    
    // ====================================================
    // Le constructeur
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
        
        print(self)
        
    } // init
    
    // ====================================================
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
    
    // ====================================================
    // Le destructeur
    deinit {
        printCouleur("\n*** Je suis le destructeur de la classe: 'MachineÀCafé' ***", .red)
        print("\t--> La machine à café a fait des ventes de \(ventesTotales) $")
    } // deinit
    
    // ====================================================
    // Les méthodes de classe
    static func quiSuisJe() -> String {
        return "Je suis une machine à café virtuelle"
    }
    
    // Les méthodes d'instance
    // ====================================================
    func infuser(_ unCafé:RecettesCafé, crème:Int = 0, sucre:Int = 0, extraFort:Bool = false) throws {

        // Générer, de façon aléatoire, un manque d'eau.
        if arc4random_uniform(10) >= 9 {
            delegate?.plusAccesADeLeau(sender:self)
            return
            // throw ErreursDeLaMachineÀCafé.plusAccèsÀUneSourceDEau
        }
        
        // Note: Dans un monde idéal, il faudrait tester la disponibilité de tous les ingrédients
        //       avant d'infuser le café.
        //       L'idée ici est de tester des concepts avancés de swift comme par exemple,
        //       générer une exception lorsque qu'il manque d'un ingrédient lors de son utilisation.

        // Note: Itération possible sur 'unCafé' grace à l'implémentation des protocoles
        //       'Sequence et IteratorProtocol' sur 'RecettesCafé'
        for _ingrédient in unCafé {
            let _quantité = RecettesCafé.ingrédientsDouble.contains(_ingrédient) ? 2:1
            // Exception passée à 'infuser() throws'
            try _ = traiterInventaire(opération: retirer, ingrédient: _ingrédient, quantité: _quantité)
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
    func traiterInventaire( opération: ( _ ing:RecettesCafé, _ quant:Int) throws -> Bool, ingrédient:RecettesCafé, quantité:Int) rethrows -> Bool {
        return try opération(ingrédient, quantité)
    } // traiterInventaire
    
    
    // ====================================================
    /// Permet d'ajouter une quantité à un ingrédient de la machine à café.
    func ajouter( ingrédient :RecettesCafé, quantité :Int) throws -> Bool  {
        print("Inventaire: ajouter")
        // guard ... else { throw ErreursDeLaMachineÀCafé.impossibleAjouterInventaire }
        return true
    } // ajouter
    
    
    // ====================================================
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

        // Détecter les ingrédients de type 'double'
        // TODO: refactorer
        var _ingrédient = ingrédient
        switch ingrédient {
        case RecettesCafé.doubleCafé: _ingrédient = .café
        case RecettesCafé.doubleSucre: _ingrédient = .sucre
        case RecettesCafé.doubleCrème: _ingrédient = .crème
        default:break
        }
        
        inventaireMachineCafé[_ingrédient]! -= quantité
        
        return true
    }  // retirer
    
    // ====================================================
    func disponibilité( ingrédient :RecettesCafé, quantité :Int) throws -> Bool  {
        let pluriel = quantité > 1 ?"s":""

        // Détecter les ingrédients de type 'double'
        // TODO: refactorer
        var _ingrédient = ingrédient
        switch ingrédient {
        case RecettesCafé.doubleCafé: _ingrédient = .café
        case RecettesCafé.doubleSucre: _ingrédient = .sucre
        case RecettesCafé.doubleCrème: _ingrédient = .crème
        default:break
        }

        print("\(quantité) \(_ingrédient)\(pluriel) à inventaire de [\(inventaireMachineCafé[_ingrédient]!)]")
        return inventaireMachineCafé[_ingrédient]! >= quantité ? true : false
            
    } // disponibilité

/*
    // ====================================================
    private func traiterLesIngrédients(café:RecettesCafé) throws
    {
        //TODO: implémenter les protocoles Sequence et IteratorProtocol sur RecettesCafé
        //      pour pouvoir itérer sur les ingrédients de la recette 
        //      et éliminer les "if café.contains()"
        print("Traitement des ingrédients requis pour fabriquer un [\(café)]\n")
        //let _quantité = RecettesCafé.ingrédientsDouble.contains(<#T##member: RecettesCafé##RecettesCafé#>)
        for _ingrédient in café {
          //TODO:
            // print("for ingrédient in café: ingrédient = \(_ingrédient)")
            let _quantité = RecettesCafé.ingrédientsDouble.contains(_ingrédient) ? 2:1
            try _ = traiterInventaire(opération: retirer, ingrédient: _ingrédient, quantité: _quantité)
        }
        
        // Voici le code requis avant l'implémentation du protocole IteratorProtocol sur RecettesCafé
        // ********************************************************
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
        // ********************************************************
        
    } // traiterLesIngrédients
 */
    
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
    func obtenirInventaire() -> (café:Int, goblet:Int, couvercle:Int, sucre:Int, crème:Int, cannelle:Int, vanille:Int, vente:Float ){
        return (inventaireMachineCafé[.café]!,
                inventaireMachineCafé[.goblet]!,
                inventaireMachineCafé[.couvercle]!,
                inventaireMachineCafé[.sucre]!,
                inventaireMachineCafé[.crème]!,
                inventaireMachineCafé[.cannelle]!,
                inventaireMachineCafé[.vanille]!,
                ventesTotales)
    } // obtenirInventaire()
    
} // MachineÀCafé


// ====================================================
// Ajout de fonctionnalités à la classe 'MachineÀCafé'
// ====================================================

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
        texteInventaire    += "\n Café:      \(inventaire.café)"
        texteInventaire    += "\n Goblet:    \(inventaire.goblet)"
        texteInventaire    += "\n Couvercle: \(inventaire.couvercle)"
        texteInventaire    += "\n Sucre:     \(inventaire.sucre)"
        texteInventaire    += "\n Crème:     \(inventaire.crème)"
        texteInventaire    += "\n Cannelle:  \(inventaire.cannelle)"
        texteInventaire    += "\n Vanille:   \(inventaire.vanille)"
        texteInventaire    += "\n Vente:     \(numberFormatter.string(from: NSNumber(value: inventaire.vente))!)\n" // String(format: "%2.2f $" , inventaire.vente)
        texteInventaire    += "*********************************\n"
        
        return texteInventaire
    } // FormaterInventaire
    
}
