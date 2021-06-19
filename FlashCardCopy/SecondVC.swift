//
//  SecondVC.swift
//  FlashCardCopy
//
//  Created by Irina Perepelkina on 18.06.2021.
//  Copyright © 2021 Irina Perepelkina. All rights reserved.
// The whole VC devoted to implementation of one function - save the card

import UIKit
import CoreData

class SecondVC: UIViewController {
    
    var questionLabel = UITextView()
    var answerLabel = UITextView()
    var saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    func configureUI() {
        configureQuestionLabel()
        configureAnswerLabel()
        configureSaveButton()
    }
    
    func configureQuestionLabel() {
        view.addSubview(questionLabel)
        questionLabel.frame = CGRect(x: 30, y: 130, width: 350, height: 100)
        questionLabel.textAlignment = .center
        questionLabel.textColor = .brown
        questionLabel.backgroundColor = .white
        questionLabel.text = "Question"
    }
    
    func configureAnswerLabel() {
        view.addSubview(answerLabel)
        answerLabel.frame = CGRect(x: 30, y: 270, width: 350, height: 180)
        answerLabel.textAlignment = .center
        answerLabel.textColor = .brown
        answerLabel.backgroundColor = .white
        answerLabel.text = "Answer"
    }
    
    func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.frame = CGRect(x: 30, y: 500, width: 350, height: 60)
        saveButton.setTitle("Save Card", for: .normal)
        saveButton.setTitleColor(.brown, for: .normal)
        saveButton.backgroundColor = .white
        saveButton.addTarget(self, action: #selector(saveCard), for: .touchUpInside)
    }
    
    @objc func saveCard() {
        
        var newCard = NSEntityDescription.insertNewObject(forEntityName: "Card", into: managedObjectContext) as! Card
        
        newCard.question = questionLabel.text
        newCard.answer = answerLabel.text
        
        do {
            try managedObjectContext.save()
            print("Successfully saved new card")
        }
        catch {
            print("Failed to save new card")
        }

        present(FirstVC(), animated: true, completion: nil)
    }

}
