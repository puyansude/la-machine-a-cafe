//
//  RecettesCafé.swift
//  TIM.Café
//
//  Created by Alain on 17-03-16.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

// ====================================================
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

// ====================================================
struct RecettesCafé :   OptionSet,
    Hashable,
    CustomStringConvertible,
    Sequence, IteratorProtocol
{
    
    // ====================================================
    // Implémentation du protocole OptionSet: donne accès à des fn de la théorie des ensembles: test, union, intersection, ...
    // Par exemple: unCafé.contains(.crème)
    let rawValue: Int
    
    // ====================================================
    // Implémentation du protocole Hashable -> programmer un getter pour 'hashValue'
    // La variable 'hashValue' sera utilisée dans un contexte d'indice.
    // Par exemple, au lieu de unTableau[RecettesCafé.crème.rawValue] il sera
    // possible d'utiliser la forme unTableau[RecettesCafé.crème]
    // https://fr.wikipedia.org/wiki/Fonction_de_hachage
    var hashValue: Int {
        return self.rawValue
    } // hashValue
    
    // ====================================================
    // Implémentation des protocoles 'Sequence et IteratorProtocol':
    // permet de boucler sur la structure de données.
    // mutating func next() -> T? {}
    var remainingBits:Int
    var bitMask = 1
    var maxBitMaskLenght = 16 // TEMP:
    // ====================================================
    
    
    // Note: Le constructeur est requis pour la méthode next() qui retourne une instance de self.
    init(rawValue: Int) {
        self.rawValue = rawValue
        remainingBits = self.rawValue
    }
    
    init(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }
    
    // ====================================================
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
    
    // ====================================================
    // Recettes
    typealias RC = RecettesCafé
    static let caféMaison:RC        = [.goblet, .couvercle, .café, .sucre, .crème]
    static let espresso:RC          = [.goblet, .café]
    static let cappuccino:RC        = [.goblet, .doubleCafé, .doubleCrème, .cannelle]
    static let latte:RC             = [.goblet, .café, .doubleCrème]
    static let affogato:RC          = [.goblet, .couvercle, .doubleCafé, .sucre, .doubleCrème, .vanille]
    static let mocha:RC             = [goblet, café, doubleCrème, doubleSucre] // valide sans le . mais pas d'aide de Xcode pour proposer des choix possibles.
    static let ingrédientsDouble:RC = [.doubleCafé, .doubleCrème, .doubleSucre]
    
    // ====================================================
    var description:String {
        switch self {
        case RecettesCafé.goblet: return "goblet"
        case RecettesCafé.couvercle: return "couvercle"
        case RecettesCafé.café: return "café"
        case RecettesCafé.doubleCafé: return "double café"
        case RecettesCafé.sucre: return "sucre"
        case RecettesCafé.doubleSucre: return "double sucre"
        case RecettesCafé.crème: return "crème"
        case RecettesCafé.doubleCrème: return "double crème"
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
    
    
    // Implémentation de l'itérateur:
    // Cet itérateur parcourt les ingrédients d'une recette
    // Un ingrédient est présent si son bit est == 1
    mutating func next() -> RecettesCafé? {
        //           print("---> Itérateur de RecettesCafé: masque des ingrédients = \(rawValue.toBin(longeurChaineBinaire))")
        while remainingBits != 0 { // Tant qu'il y a des bits à tester?
            defer { bitMask = bitMask &* 2 }   // permuter le masque vers la gauche à la sortie de la méthode
            if remainingBits & bitMask != 0 { // Tester le bit courant
                remainingBits = remainingBits & ~bitMask // Soustraire le bit courant aux bits à tester
                print("\n---> Itérateur de RecettesCafé: masque des ingrédients = \(rawValue.toBinWithPad())")
                print("---> Itérateur de RecettesCafé: masque d'intersection  = \(bitMask.toBinWithPad())")
                print("---> Itérateur de RecettesCafé: bits restants          = \(remainingBits.toBinWithPad())")
                print("---> Itérateur de RecettesCafé: ingrédient trouvé      = \(RecettesCafé(rawValue: bitMask))")
                
                return RecettesCafé(rawValue: bitMask)  // retourner l'ingrédient courant
            }
        }
        return nil
    } // next()
    
} // struct RecettesCafé

// ====================================================
// Énumération des types de café
enum TypesCafé:String {
    case café = "café maison"
    case espresso
    case latte
    case cappuccino
    case affogato
    case mocha
}
