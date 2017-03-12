//
//  ViewController.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//

import UIKit


class ViewController: UIViewController, MachineÀCaféDelegate {
    
    let uneMachineÀCafé = MachineÀCafé()
    
    @IBAction func acheterUnCafé(_ sender: Any) {
        do {
            try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .cappuccino, crème: 2, sucre: 1)
            print(uneMachineÀCafé.texteInventaire())
        }catch
        {
            print("Erreur:  Problème avec la machine à café!: error = \(error)")
        }
    }
    
    override func   {
        super.viewDidLoad()
        uneMachineÀCafé.delegate = self
        /*
         do {
         for _ in 0...9 {
         try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .cappuccino ,crème: 1, sucre: 0, extraFort: true)
         } // for
         
         } catch
         {
         print("Erreur:  Problème avec la machine à café!: error = \(error)")
         }
         */
        
    } // viewDidLoad
    
    func plusAccesADeLeau(sender: MachineÀCafé) {
        print("Erreur: La machine à café n'a plus accès à de l'eau!")
    } // plusAccesADeLeau
    
} // ViewController

