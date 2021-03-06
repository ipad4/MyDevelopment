//
//  ViewController_block.swift
//  MyDevelopmentSwift
//
//  Created by hanyfeng on 16/4/16.
//  Copyright © 2016年 MD. All rights reserved.
//已看

import UIKit


class ViewController_Closures: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    
    func_noescape();
  }
  
  
  //MARK:- < 推导例子 闭包的写法 尾随闭包 >
  //MARK:推导例子 - 排序
  func func1() {
    
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"];
    
    var reversed:[String];
    
    //原始
    func backwards(s1: String, s2: String) -> Bool {
      return s1 < s2
    }
    
    reversed = names.sort(backwards);
    
    //优化
    reversed = names.sort({(s1: String, s2: String) -> Bool in return s1 > s2});
    reversed = names.sort({ s1, s2 in return s1 > s2 });
    reversed = names.sort({s1, s2 in s1 > s2});
    reversed = names.sort({ $0 > $1 } );
    reversed = names.sort(){$0>$1}//trailing闭包
    reversed = names.sort{$0>$1}
    reversed = names.sort(>);
    
    for i in reversed {
      print(i);
    }
  }
  
  
  
  //MARK:闭包的写法 - 转换数字为对应英文
  func func_closures() {

    let digitNames = [
      0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four",
      5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
    ];
    
    let numbers = [16, 510, 58];
    
    
    let strings = numbers.map {
      (number) -> String in //参数 返回值（参数名自己定，类型系统会自己推导）
      
      //函数体
      var output = "";
      var num = number;
      while num > 0 {
        output = digitNames[num % 10]! + output;
        num /= 10;
      }
      return output;
    };
    
    print(strings);
  }
  
  
  //MARK:trailing闭包
  func func_trailingClosures() {

    func2_1({print("~~")});//原来
    func2_1(){print("@@@")};//trailing闭包
    func2_1{print("@@@")};//无参数可以把()去掉
  }
  
  func func2_1(block:()->()){
    for _ in 0...2 {
      block();
    }
  }
  
  //MARK:- < 捕获值 嵌套函数是最简单的可捕获值闭包；闭包可以在作用域外引用和修改捕获的值，因为闭包和函数是引用类型 >
  func func3_result() {
    

    //捕获值
    var function = func3_2_2(forIncrement: 2);//~0
    var result = function(10);//12
    result = function(10);//24
    print(result);
    
    //新的变量拥有新的引用 跟上面的不相关
    function = func3_2_2(forIncrement: 7);//~0
    result = function(7);//14
    result = function(7);//28
    print(result);
    
  }
  
  
  //MARK:捕获值
  func func3_2_2(forIncrement amount:Int)->((Int)->Int){
    
    var runningTotal:Int = 0;
    print("~\(runningTotal)")//只输出1次
    
    func func3_2_2_base(value:Int) -> Int {
      runningTotal += amount;//捕获runningTotal和amount的值
      runningTotal += value;
      return runningTotal;
    }
    
    return func3_2_2_base;//如果返回的是函数类型，则不用加括号
  }

  
  //MARK:- <用闭包定义变量的两种方式 做函数参数 做返回值>
  //MARK:用闭包定义变量的两种方式
  func func4_1() {
    
    let name:String = {
      return "name";
    }()
    
    let name1:()->String = {//自动闭包
      return "name1"
    }
    
    print("~~~\(name) \(name1())");
    
    
  }

  //MARK:闭包做返回值
  func funcResult5() {
    
    let result:String = func5_1()();
    print(result);
    
    let result1 = func5_2()("1",1)
    print(result1);
    
  }
  
  //返回值 简单
  func func5_1() -> (()->String) {
    
    var bb:()->String = {
      return "name1111~"
    }
    
    //或者这样
    bb = {
      ()->String in
      return "name1111~"
    }

    
    return bb;
  }
  
  //返回值 稍复杂
  func func5_2base(name name:String,age:Int) -> (reName:String,reAge:String) {
    return(name,String(age));
  }
  
  func func5_2() -> ((String,Int)->(String,String)) {
    
    var bb:(String,Int)->(String,String)
    
    bb = {
      (str:String,num:Int)->(String,String)in
      return(str,String(num));
    }
    
    //或者这样
    bb = func5_2base
    
    
    return bb;
  }
  
  //MARK:闭包做参数
  func func5_4Result() {
    
    let bb:(Int)->Int = {
      (num:Int)->Int in
      return num*num;
    }
    print(bb(5));
    
    let result = func5_4_1(bb);
    print(result);
    
    
    func5_4_2({print("hello~")});
    func5_4_2{print("~~~~")}

  }
  
  func func5_4_1(block:(Int)->Int) -> Int{
    let result = block(2);
    return result;
  }
  
  func func5_4_2(block:()->()){
    for _ in 0...2 {
      block()
    }
  }
  
  //MARK:- < @noescape >
  /*
   修饰的闭包在函数结束后也会随之结束，用于告诉编译器优化性能
   
   什么情况下一个闭包参数会跳出函数的生命期呢？很简单，我们在函数实现内，将一个闭包用 dispatch_async 嵌套，这样这个闭包就会在另外一个线程中存在，从而跳出了当前函数的生命期。这样做主要是可以帮助编译器做性能的优化。
   */
  func func_noescape() {
    
    let instance = SomeClass()
    
    instance.doSomething()
    
    print(instance.x)
    // Prints "200"
    
    completionHandlers.first?()
    print(instance.x)
    // Prints "100"
    
  }
  
  //MARK:- < 自动闭包 >
  func func_autoClosures(){
    
    var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    print(customersInLine.count)
    // Prints "5"
    
    //定义一个自动闭包
    let customerProvider = {
      return customersInLine.removeAtIndex(0)
    }
    //相当于
//    let customerProvider:()->String = {
//      return customersInLine.removeAtIndex(0)
//    }
    
    print(customersInLine.count)
    // Prints "5"
    
    print("Now serving \(customerProvider())!")
    // Prints "Now serving Chris!"
    print(customersInLine.count)
    // Prints "4"
  }
  
  
}


//MARK:- ****************************** class ******************************

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: () -> Void) {
  completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(@noescape closure: () -> Void) {
  closure()
}

class SomeClass {
  
  var x = 10
  
  func doSomething() {
    someFunctionWithEscapingClosure { self.x = 100 }
    someFunctionWithNonescapingClosure { x = 200 }//可以隐式self
  }
}
