//
//  ViewController.swift
//  Project 5
//
//  Created by Pranjal Verma on 01/07/24.
//

import UIKit

class ViewController: UITableViewController {

  var allWords = [String]()
  var useWords = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
   
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
  
    if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordUrl) {
        allWords = startWords.components(separatedBy: "\n")
      }
    }else {
         allWords = ["silkworm"]
    }

    startGame()
  }
  
  func startGame() {
    title = allWords.randomElement()
    useWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    useWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    
    cell.textLabel?.text = useWords[indexPath.row]
    
    return cell
  }

  @objc func promptForAnswer() {
    let ac = UIAlertController(title: "Enter", message: nil, preferredStyle: .alert)
    ac.addTextField()
   
    let submitAnswer = UIAlertAction(title: "Submit", style: .default) {
      [weak self, weak ac] action in
      guard let answer = ac?.textFields?[0].text else { return }
      self?.submit(answer)
    }
    
    ac.addAction(submitAnswer)
    present(ac , animated: true)
  }
  
func isPossible(word: String) -> Bool{
    guard var latters = title?.lowercased() else { return false }
    
   for i in word {
        if let index = latters.firstIndex(of: i) {
          latters.remove(at: index)
        }else {
          return false
        }
   }
    
    return true
}
  
  func isOrignal(word: String) -> Bool{
    return !useWords.contains(word)
  }

  func isReal(word: String) -> Bool{
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "eg")
    
    return misspelledRange.location == NSNotFound
  }

  func submit(_ answer: String) {
    let lowerAnswer = answer.lowercased()
    
    let errorTitle: String
    let errorMessage: String
    
    if isPossible(word: lowerAnswer) {
      if isOrignal(word: lowerAnswer) {
        if isReal(word: lowerAnswer) {
          useWords.insert(answer, at: 0)
          
          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
          
          return
        }else {
          errorTitle = "Word not recognised"
          errorMessage = "You can't just make them up, You know!"
        }
      }else {
        errorTitle = "Word used already"
        errorMessage = "Be more orignal!"
      }
    }else {
      guard let title = title?.lowercased() else { return }
      errorTitle = "Word Not possible"
      errorMessage = "You can't spell that word from \(title)"
    }
    
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    present(ac, animated: true)
  }

}

