//
//  ViewController.swift
//  TIM.Café
//
//  Created by Alain on 17-03-06.
//  Copyright © 2017 Alain. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("yo")
        let uneMachineÀCafé = MachineÀCafé()
        do {
            for _ in 0...9 {
                try uneMachineÀCafé.fabriquerUnCafé(typeCafé: .cappuccino ,crème: 1, sucre: 0, extraFort: true)
            } // for

        } catch
        {
            print("Erreur:  Problème avec la machine à café!: error = \(error)")
        }

    print(uneMachineÀCafé.obtenirInventaire().vente)
        
    } // viewDidLoad
 
} // ViewController

