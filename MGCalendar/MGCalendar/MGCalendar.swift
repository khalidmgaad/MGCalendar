//
//  MGCalendar.swift
//  MGCalendar
//
//  Created by nawal amallou on 31/03/2020.
//  Copyright © 2020 nawal amallou. All rights reserved.
//

import UIKit


protocol MGCalendarDelegate {
    func MGCalendarDateChanged(newDate: Date)
}

class MGCalendar: UIView {

    //MARK: Variables
    var delegate : MGCalendarDelegate?
    var isDrawn = false
    var calendar: Calendar!
    var currentDate: Date! {
        didSet {
            self.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            self.dayButtons.removeAll()
            draw(self.frame)
            
            delegate?.MGCalendarDateChanged(newDate: self.currentDate)
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
    
    private var dayButtons = [UIButton]()
    private var dateLabel : UILabel!
    
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
            button.titleLabel?.font = UIFont(name: "Nunito-Light", size: 13)
            button.tag = day
            button.addTarget(self, action: #selector(dayTapped(sender:)), for: .touchUpInside)
            monthDaysView.addSubview(button)
            day+=1
            
            if self.day == day-1 {
                button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 15)
            }
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
        
        dateLabel = UILabel(frame: headerView.bounds)
        dateLabel.text = stringFromDate(date: currentDate, formate: "dd MMMM yyyy")
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "Nunito-Bold", size: 18)
        dateLabel.textAlignment = .center
        headerView.addSubview(dateLabel)
        
    }
    
    @objc func dayTapped(sender: UIButton){
        let day = sender.tag
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        currentDate = formatter.date(from: "\(day) \(self.month) \(self.year)")
    }
    
    @objc func prevTapped() {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {return}
        currentDate = currentDate.addingTimeInterval(TimeInterval(-3600*24*range.count))
    }
    
    @objc func nextTapped() {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {return}
        currentDate = currentDate.addingTimeInterval(TimeInterval(3600*24*range.count))
    }
    
    func firstWeekDay(of Month: Int) -> Int?{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        let date = formatter.date(from: stringFromDate(date: currentDate, formate: "1 MM yyyy")!)
        calendar = Calendar.current
        let comps = calendar.dateComponents([.month,.weekday], from: date!)
        
        return comps.weekday
    }
    
    func style() {
        cornerRadius = 20
        applyGradient(colors: [UIColor(hex: "#9ED3DB")!,UIColor(hex: "#6CB6C1")!])
        addShadow(color: .red, opacity: 1, radius: 10)
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
        
        isDrawn = true
    }
    
    override func awakeFromNib() {
        self.calendar = Calendar.current
        self.currentDate = Date()
    }
    
}
