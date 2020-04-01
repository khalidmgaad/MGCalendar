//
//  MGCalendar.swift
//  MGCalendar
//
//  Created by nawal amallou on 31/03/2020.
//  Copyright © 2020 nawal amallou. All rights reserved.
//

import UIKit

@IBDesignable
class MGCalendar: UIView {

    //MARK: Variables
    var calendar: Calendar!
    var currentDate: Date! {
        didSet {
            print("NEW DATE > \(stringFromDate(date: self.currentDate, formate: "dd MM yyyy"))")
            self.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            draw(self.frame)
        }
    }
    
    var day : Int {
        get {
            return calendar.component(.day, from: currentDate)
        }
    }
    
    var month : Int {
        get {
            return calendar.component(.month, from: currentDate)
        }
    }
    
    var year : Int {
        get {
            return calendar.component(.year, from: currentDate)
        }
    }
    
    private var dayButtons : [UIButton]!
    
    private let spacing : CGFloat = 8
    private var buttonSize : CGSize {
        get {
            let width = (monthDaysView.width-(spacing*9))/7
            let availableHeight = (monthDaysView.height-(spacing*6))
            let height = availableHeight/5
            return .init(width: width, height: height)
        }
    }
    
    var headerView : UIView!
    var weekDaysView : UIView!
    var monthDaysView : UIView!
    
    //MARK: Methods
    func SetupViews(){
        
        let padding : CGFloat = 8
        
        headerView = UIView(frame: CGRect(x: padding, y: padding, width: frame.width-padding*2, height: frame.height*0.15))
        addSubview(headerView)
        
        weekDaysView = UIView(frame: CGRect(x: padding, y: headerView.xPos+headerView.height, width: frame.width-16, height: frame.height*0.1))
        addSubview(weekDaysView)
        
        monthDaysView = UIView(frame: CGRect(x: 8, y: weekDaysView.yPos+weekDaysView.height, width: frame.width-16, height: (frame.height*0.7)-padding*2))
        addSubview(monthDaysView)
    }
    
    fileprivate func positionForButton(at index: Int) -> CGPoint{
        let x = (monthDaysView.width/7)*(CGFloat(index%7))
        let y = (monthDaysView.height/6)*(CGFloat(index/7))
        return .init(x: x+spacing, y: y+spacing)
    }
    
    fileprivate func drawButtons(start: Int,length: Int) {
        let bSize = buttonSize
        var day = 1
        for i in start-1..<length+start-1 {
            let bFrame = CGRect(origin: positionForButton(at: i), size: bSize)
            let button = UIButton(frame: bFrame)
            button.setTitle("\(day)", for: .normal)
            button.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 13)
            button.tag = day
            button.addTarget(self, action: #selector(dayTapped(sender:)), for: .touchUpInside)
            monthDaysView.addSubview(button)
            day+=1
        }
    }
    
    fileprivate func drawWeekDays() {
        let hSize = buttonSize
        
        let calendar = Calendar(identifier: .gregorian)
        let weekDays = calendar.shortWeekdaySymbols
        
        for i in 0..<7 {
            let hFrame = CGRect(origin: CGPoint(x: positionForButton(at: i).x, y: 4), size: CGSize(width: hSize.width, height: weekDaysView.frame.height))
            let label = UILabel(frame: hFrame)
            label.font = UIFont(name: "Nunito-Regular", size: 12)
            label.textColor = .lightText
            label.text = weekDays[i]
            label.textAlignment = .center
            
            weekDaysView.addSubview(label)
        }
    }
    
    fileprivate func drawHeader() {
        let PrevBtn = UIButton(frame: CGRect(x: 0, y: 0, width: headerView.height, height: headerView.height))
        PrevBtn.tintColor = .white
        PrevBtn.setImage(#imageLiteral(resourceName: "prev"), for: .normal)
        PrevBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        headerView.addSubview(PrevBtn)
        PrevBtn.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        
        let NextBtn = UIButton(frame: CGRect(x: headerView.width-headerView.height, y: 0, width: headerView.height, height: headerView.height))
        NextBtn.tintColor = .white
        NextBtn.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        NextBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        headerView.addSubview(NextBtn)
        NextBtn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        let dateHolder = UILabel(frame: headerView.bounds)
        dateHolder.text = stringFromDate(date: currentDate, formate: "dd MMMM yyyy")
        dateHolder.textColor = .white
        dateHolder.font = UIFont(name: "Nunito-Bold", size: 18)
        dateHolder.textAlignment = .center
        headerView.addSubview(dateHolder)
        
    }
    
    @objc func dayTapped(sender: UIButton){
        let day = sender.tag
        currentDate = calendar.date(bySetting: .day, value: day, of: currentDate)
    }
    
    @objc func prevTapped() {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {return}
        currentDate = currentDate.addingTimeInterval(TimeInterval(-3600*24*range.count))
    }
    
    @objc func nextTapped() {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {return}
        currentDate = currentDate.addingTimeInterval(TimeInterval(3600*24*range.count))
    }
    
    func stringFromDate(date: Date,formate: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
    
    func firstWeekDay(of Month: Int) -> Int?{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        let date = formatter.date(from: stringFromDate(date: currentDate, formate: "1 MM yyyy"))
        calendar = Calendar.current
        let comps = calendar.dateComponents([.month,.weekday], from: date!)
        
        return comps.weekday
    }
    
    func style() {
        cornerRadius = 20
        applyGradient(colors: [UIColor(hex: "#9ED3DB")!,UIColor(hex: "#6CB6C1")!])
    }
    
    //MARK: Lifecycle
    override func draw(_ rect: CGRect) {
        
        let comps = calendar.dateComponents([.day,.month,.year,.weekday], from: currentDate)
        let monthStart = firstWeekDay(of: comps.month!)
        let range = calendar.range(of: .day, in: .month, for: currentDate)
    
        SetupViews()
        drawWeekDays()
        drawButtons(start: monthStart!,length: range!.count)
        drawHeader()
        
        style()

    }
    
    override func awakeFromNib() {
        self.calendar = Calendar.current
        self.currentDate = Date()
    }
    
}


//MARK: Extensions
extension UIView{
    
    var xPos : CGFloat {
        get {
            return frame.origin.x
        }
    }
    
    var yPos : CGFloat {
        get {
            return frame.origin.y
        }
    }
    
    var height: CGFloat {
        get {
            return frame.height
        }
    }
    
    var width: CGFloat {
        get {
            return frame.width
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    func applyGradient(colors: [UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map{ return $0.cgColor }
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
