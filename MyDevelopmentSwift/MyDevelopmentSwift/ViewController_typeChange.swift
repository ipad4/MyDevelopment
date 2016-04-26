//
//  ViewController_typeChange.swift
//  MyDevelopmentSwift
//
//  Created by 冯鸿辉 on 16/4/26.
//  Copyright © 2016年 MD. All rights reserved.
//

import UIKit

class ViewController_typeChange:UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    func3();
  }
  
  //MARK:- <<< method >>>
  //MARK:类型转换
  func func1() {
    
    let library = [
      Movie(name: "Casablanca", director: "Michael Curtiz"),
      Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
      Movie(name: "Citizen Kane", director: "Orson Welles"),
      Song(name: "The One And Only", artist: "Chesney Hawkes"),
      Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
    ]
    
    
    //检查类型
    var movieCount = 0
    var songCount = 0
    
    for item in library {
      if item is Movie {
        movieCount += 1
      } else if item is Song {
        songCount += 1
      }
    }
    
    print("~~Media library contains \(movieCount) movies and \(songCount) songs")
    
    //向下转型
    for item in library {
      if let movie = item as? Movie {
        print("Movie: '\(movie.name)', dir. \(movie.director)")
      } else if let song = item as? Song {
        print("Song: '\(song.name)', by \(song.artist)")
      }
    }

    
    
    
  }
  
  
  //MARK:AnyObject
  func func2() {
    
    let someObjects: [AnyObject] = [
      Movie(name: "2001: A Space Odyssey", director: "Stanley Kubrick"),
      Movie(name: "Moon", director: "Duncan Jones"),
      Movie(name: "Alien", director: "Ridley Scott")
    ]
    
    for object in someObjects {
      let movie = object as! Movie
      print("Movie: '\(movie.name)', dir. \(movie.director)")
    }
    
    //简洁
    for movie in someObjects as! [Movie] {
      print("Movie: '\(movie.name)', dir. \(movie.director)")
    }
  }
  
  //MARK:Any
  func func3(){
    
    var things = [Any]()
    
    things.append(0)
    things.append(0.0)
    things.append(42)
    things.append(3.14159)
    things.append("hello")
    things.append((3.0, 5.0))
    things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
    
    //注意必须是非可选as
    for thing in things {
      switch thing {
      case 0 as Int:
        print("zero as an Int")
      case 0 as Double:
        print("zero as a Double")
      case let someInt as Int:
        print("an integer value of \(someInt)")
      case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
      case is Double:
        print("some other double value that I don't want to print")
      case let someString as String:
        print("a string value of \"\(someString)\"")
      case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
      case let movie as Movie:
        print("a movie called '\(movie.name)', dir. \(movie.director)")
      default:
        print("something else")
      }
    }
    
  }
}


//MARK:- class
class MediaItem {
  var name: String
  init(name: String) {
    self.name = name
  }
}

class Movie: MediaItem {
  var director: String
  init(name: String, director: String) {
    self.director = director
    super.init(name: name)
  }
}

class Song: MediaItem {
  var artist: String
  init(name: String, artist: String) {
    self.artist = artist
    super.init(name: name)
  }
}