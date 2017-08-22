//
//  ViewController.swift
//  supApp
//
//  Created by Neil Patel on 8/3/17.
//  Copyright © 2017 Neil Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var supButton: UIButton!
    @IBOutlet weak var responseText: UILabel!
    @IBOutlet weak var supCount: UILabel!
    @IBOutlet weak var resetSup: UIButton!
    @IBOutlet weak var snarkLabel: UILabel!
    @IBOutlet weak var cumulativeCountLabel: UILabel!
    

    @IBOutlet weak var collectionView: UICollectionView!
    var sections = [String]()
    var rows = [""]
    var snarkArray = ["Wow, you've got some momentum", "Look at you go", "You're pretty good at Supping!", "Trump is President", "You'll never finish this", "What are you procrastinating?", "Proud of you", "What are you up to this weekend?", "Sup with the world today huh?", "Do or do not. There is no try", "The regret of not going for it is the worst of all regret", "Sup?", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",]
    var articles: [Article]? = []
    

    
    // when the view loads, this stuff happens
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = supButton!
        //button.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
     
        // customizing size of collectionview cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 15, height: 15)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        view.addSubview(button) // ?
        
        cumulativeCountLabel.text = "Lifetime: \(UserDefaults.standard.integer(forKey: "cumulativeCount"))"

        
        fetchArticles() // JSON fetching

        
    }
    // JSON fetching
    
    func fetchArticles() {
        // needed to load task
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=78bd005126e443af8c0fd51b74d5bebd")!)
        
        // when executes, will give data,response,error
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
        if error != nil {
            print(error!)
            return // we do not want to continue completion block, just jump out of function.
        }
        // past the error, so you can initialize array here. Was optional before. Clears the array from before.
            self.articles = [Article]()
        // json serialization in do try catch block
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
            if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                for articleFromJson in articlesFromJson {
                    let article = Article() // article of class Article
                    if let title = articleFromJson["title"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String {
                    
                        article.headline = title
                        article.desc = desc
                        article.url = url
                        
                    }
                    
                    self.articles?.append(article)
                    
                }
            }
            
        } catch let error {
            print(error)
        }
     

            
    }
        // fires URL session
        task.resume()
        

       
}

    // activating the functionality of the button. toggles the text
    
    var count = 0
    var cumulativeCount = 0
    
    @IBAction func supButtonPressed(_ sender: UIButton) {
        count += 1
        cumulativeCount += 1
        supButton.setTitle("\(count)", for: .normal)
        
        // create some conditionals
        sections.append("x")
        collectionView.reloadData()

        if sections.count % 25 == 0 {
            
            let randomIndex = Int(arc4random_uniform(UInt32((articles?.count)!)))
            snarkLabel.text = "\(articles![randomIndex].headline!) \n\n \(articles![randomIndex].desc!) \n\n \(articles![randomIndex].url!)"

        }
        
        // trying to get cumulative count data to safe after app closes.
        UserDefaults.standard.set(cumulativeCount, forKey: "cumulativeCount")
        cumulativeCountLabel.text = "Lifetime: \(UserDefaults.standard.integer(forKey: "cumulativeCount"))"
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "cumulativeCount") as? Int {
            cumulativeCount = x
        }
    }

    @IBAction func endSupPressed(_ sender: UIButton) {
        count = 0
        sections = [String]()
        rows = [""]
        supButton.setTitle("Sup?", for: .normal)
        collectionView.reloadData()


    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows.count // this means number of rows = sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count // this is number of columns
    }
    
    // this one responsible for displaying cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tickCell", for: indexPath)
        
        return cell
    }
    
  
    
   



}

// To do: (segmented, step by step instructions. Think programatically. Bite sized problems.

// X Make button round
// X Make button say show sup when you click it
// X Add counter
// X For every 100 Sups, you get a tick mark. Maybe use a collectionView. Understand functionality and see what you can do.
// X Cumulative tracker of number of SUPs, that maintains itself each time after you login.
// X Need an end goal. After each line
// X what happens when you hit end of screen? just keep it going forever
// X Add newsAPI headlines after each line. Try to pull from variety of sources.
// X Figure out why text is not wrapping
// X fix ICON size

// Store total record of sups in leaderboard, personal best. Cumulative counter

// Ship to Aaron
