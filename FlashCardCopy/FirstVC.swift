//
//  FirstVC.swift
//  FlashCardCopy
//
//  Created by Irina Perepelkina on 18.06.2021.
//  Copyright © 2021 Irina Perepelkina. All rights reserved.
//

import UIKit
import CoreData

let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
var bankOfCards = [Card]()

class FirstVC: UIViewController {

    var currentCard: Card!
    var newCardButton = UIButton()
    var questionOrAnswerSegControl = UISegmentedControl()
    var contentLabel = UILabel()
    var deleteCardButton = UIButton()
    
    enum SegmentMode {
        case questionFirst
        case answerFirst
    }
    
    var chosenControlMode: SegmentMode = .questionFirst

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        configureUI()
        fetchCards()
        displayCard()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCards()
        displayCard()
    }
    
    
    func configureUI() {
        buttonConfiguration()
        segmentedContrConfiguration()
        configureContentLabel()
        deleteButtonConfiguration()
        configureSwipeUp()
        configureSwipeDown()
        configureSwipeLeft()
    }
    
    func fetchCards() {
        
        let request: NSFetchRequest<Card> = Card.fetchRequest() /* on every NSManagedObject we can call a fetchRequest function, we need to know what kind of object we fetch from core data that's why specify the type as <Card> */
        
        do {
            bankOfCards = try managedObjectContext.fetch(request)
        }
        catch {
            print("Failed to fetch cards from a db")
        }
        
    }
    
    func displayCard() {
        if bankOfCards.isEmpty {
            contentLabel.text = "No cards to display"
        }
        else {
            let index = Int (arc4random_uniform(UInt32(bankOfCards.count)))
            
            currentCard = bankOfCards[index]
            
            if chosenControlMode == .questionFirst {
                contentLabel.text = currentCard.question
            }
            else {
                contentLabel.text = currentCard.answer
            }
        }
    }
    
    // MARK: - UI configuration methods
    
    func configureSwipeDown() {
        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(showQuestion))
        swipeDown.direction = .down
        contentLabel.addGestureRecognizer(swipeDown)
        contentLabel.isUserInteractionEnabled = true
    }
    
    @objc func showQuestion() {
        if chosenControlMode == .answerFirst {
            contentLabel.text = currentCard.question
        }
    }
    
    func configureSwipeUp() {
        var swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(showAnswer))
        swipeUp.direction = .up
        contentLabel.addGestureRecognizer(swipeUp)
        contentLabel.isUserInteractionEnabled = true
    }
    
    @objc func showAnswer() {
        if chosenControlMode == .questionFirst {
            contentLabel.text = currentCard.answer
        }
    }
    
    func configureSwipeLeft() {
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(changeCard))
        swipeLeft.direction = .left
        contentLabel.addGestureRecognizer(swipeLeft)
        contentLabel.isUserInteractionEnabled = true
    }
    
    @objc func changeCard() {
        if bankOfCards.isEmpty {
            contentLabel.text = "No cards to display"
        }
        else {
            let index = Int (arc4random_uniform(UInt32(bankOfCards.count)))
            
            currentCard = bankOfCards[index]
            
            if chosenControlMode == .questionFirst {
                contentLabel.text = currentCard.question
            }
            else {
                contentLabel.text = currentCard.answer
            }
        }
    }
    
    func deleteButtonConfiguration() {
        view.addSubview(deleteCardButton)
        deleteCardButton.frame = CGRect(x: 30, y: 700, width: 350, height: 60)
        deleteCardButton.setTitleColor(.brown, for: .normal)
        deleteCardButton.setTitle("Delete Card", for: .normal)
        deleteCardButton.backgroundColor = .white
        deleteCardButton.addTarget(self, action: #selector(deleteCard), for: .touchUpInside)
    }
    
    @objc func deleteCard() {
        managedObjectContext.delete(currentCard)
        do {
            try managedObjectContext.save()
        }
        catch {
            print("Failed to save database after deletion")
        }
        fetchCards()
        displayCard()
    }
    
    func configureContentLabel() {
        view.addSubview(contentLabel)
        contentLabel.frame = CGRect(x: 30, y: 330, width: 350, height: 250)
        contentLabel.textAlignment = .center
        contentLabel.text = "Content"
        contentLabel.backgroundColor = .white
        contentLabel.textColor = .brown
        contentLabel.numberOfLines = 20
    }
    
    func segmentedContrConfiguration() {
        view.addSubview(questionOrAnswerSegControl)
        questionOrAnswerSegControl.translatesAutoresizingMaskIntoConstraints = false
        questionOrAnswerSegControl.topAnchor.constraint(equalTo: newCardButton.bottomAnchor, constant: 60).isActive = true
        questionOrAnswerSegControl.leadingAnchor.constraint(equalTo: newCardButton.leadingAnchor).isActive = true
        questionOrAnswerSegControl.trailingAnchor.constraint(equalTo: newCardButton.trailingAnchor).isActive = true
        questionOrAnswerSegControl.backgroundColor = .white
        questionOrAnswerSegControl.insertSegment(withTitle: "Question First", at: 0, animated: true)
        questionOrAnswerSegControl.insertSegment(withTitle: "Answer First", at: 1, animated: true)
        questionOrAnswerSegControl.selectedSegmentIndex = 0
        questionOrAnswerSegControl.addTarget(self, action: #selector(setSegmentedControlMode), for: .valueChanged)
    }
    
    @objc func setSegmentedControlMode() {
        
        let index = questionOrAnswerSegControl.selectedSegmentIndex
        
        print("Segmented control is called")
        
        switch index {
            case 0:
                chosenControlMode = .questionFirst
            print("Chose question to answer as default")
            case 1:
                chosenControlMode = .answerFirst
            print("Chose answer to question as default")
            default:
                chosenControlMode = .questionFirst
        }
    }
    
    func buttonConfiguration() {
        view.addSubview(newCardButton)
        // constraints below can be subsituted with a singe set frame property
        newCardButton.translatesAutoresizingMaskIntoConstraints = false
        newCardButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        newCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        newCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        newCardButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        newCardButton.titleLabel?.textAlignment = .center
        newCardButton.backgroundColor = .white
        newCardButton.setTitle("New card", for: .normal)
        newCardButton.setTitleColor(.brown, for: .normal)
        newCardButton.addTarget(self, action: #selector(moveToSecondVC), for: .touchUpInside)
    }
    
    
    @objc func moveToSecondVC() {
        var secondVCInstance = SecondVC()
        secondVCInstance.view.backgroundColor = .green
        present(secondVCInstance, animated: true, completion: nil)
    }

}
