//
//  ViewController.swift
//  URExampleScrollingAnimator
//
//  Created by DongSoo Lee on 2017. 3. 27..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import Lottie

let DefaultParallaxScrollRatio: CGFloat = 1.38

class URExampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

//    @IBOutlet var parallaxBackgroundView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var refreshImageView: UIImageView!
    @IBOutlet var scrollView1: UIScrollView!
    @IBOutlet var refreshImageView1: UIImageView!
    var lotAnimationView: LOTAnimationView!

    @IBOutlet var slParallexScrollRatio: UISlider!
    @IBOutlet var lbParallexScrollRatioMin: UILabel!
    @IBOutlet var lbParallexScrollRatioMax: UILabel!
    @IBOutlet var lbParallexScrollRatioCurrent: UILabel!

    @IBOutlet var btnInitRatio: UIButton!

    var parallaxScrollRatio: CGFloat = DefaultParallaxScrollRatio {
        didSet {
            self.lbParallexScrollRatioCurrent.text = "\(self.parallaxScrollRatio)"

            self.parallaxScrollRatio1 = self.parallaxScrollRatio * DefaultParallaxScrollRatio * 1.5
        }
    }

    var parallaxScrollRatio1: CGFloat = DefaultParallaxScrollRatio * DefaultParallaxScrollRatio * 1.5

    var girlImages: [UIImage] = [#imageLiteral(resourceName: "suzy1"), #imageLiteral(resourceName: "suzy2"), #imageLiteral(resourceName: "suzy3"), #imageLiteral(resourceName: "suzy4"), #imageLiteral(resourceName: "seolhyun1"), #imageLiteral(resourceName: "seolhyun2"), #imageLiteral(resourceName: "seolhyun3"), #imageLiteral(resourceName: "seolhyun4")]
    var girlTexts: [String] = ["Suzy in korean transitional dress", "Suzy during an interview", "Smiling Suzy", "Brightly Smiling Suzy", "SeolHyun wearing a swimming suit", "SeolHyun standing nicely", "SeolHyun carrying a cute bag", "SeolHyun laying down"]

    var boyImages: [UIImage] = [#imageLiteral(resourceName: "seokangjun1"), #imageLiteral(resourceName: "seokangjun2"), #imageLiteral(resourceName: "joinsung1"), #imageLiteral(resourceName: "joinsung2"), #imageLiteral(resourceName: "joinsung3"), #imageLiteral(resourceName: "gosu1"), #imageLiteral(resourceName: "gosu2"), #imageLiteral(resourceName: "jungwoosung1"), #imageLiteral(resourceName: "jungwoosung2")]
    var boyTexts: [String] = ["KangJun with 'V'", "KangJun in suit", "InSung's face at the left side", "InSung is looking at me", "Dandy InSung", "GoSu", "GoSu with scarf", "WooSung in suit", "WooSung is looking at somewhere"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.initView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.initScroll()
    }

    func initView() {
        self.scrollView1.backgroundColor = UIColor(red: 1.0, green: 0xae / 0xff, blue: 0.0, alpha: 1.0)

        self.btnInitRatio.layer.cornerRadius = 5.0

        self.initValues()

        self.lbParallexScrollRatioMin.text = "\(self.slParallexScrollRatio.minimumValue)"
        self.lbParallexScrollRatioMax.text = "\(self.slParallexScrollRatio.maximumValue)"
        self.lbParallexScrollRatioCurrent.text = "\(self.slParallexScrollRatio.value)"

        self.lotAnimationView = LOTAnimationView(name: "data")
        self.refreshImageView1.layoutIfNeeded()
        self.lotAnimationView.frame = self.refreshImageView1.bounds
        self.scrollView1.addSubview(self.lotAnimationView)
    }

    func initValues() {
        self.parallaxScrollRatio = DefaultParallaxScrollRatio
        self.slParallexScrollRatio.value = Float(DefaultParallaxScrollRatio)
    }

    func initScroll() {
        self.scrollView1.contentOffset = CGPoint(x: self.scrollView1.contentOffset.x, y: (-self.refreshImageView.bounds.height) * CGFloat(self.slParallexScrollRatio.value) / DefaultParallaxScrollRatio)

        self.preOffsetY1 = (-self.refreshImageView.bounds.height) * CGFloat(self.slParallexScrollRatio.value) / DefaultParallaxScrollRatio

        self.isHapticFeedbackEnabled = true
    }

    @IBAction func tapInitRatio(_ sender: Any) {
        self.initValues()

        self.initScroll()
    }

    @IBAction func changeParallexScrollRatio(_ sender: Any) {
        let value = roundUp(Double(self.slParallexScrollRatio.value), roundUpPosition: 2)
        self.parallaxScrollRatio = CGFloat(value)
        self.slParallexScrollRatio.setValue(Float(value), animated: false)

        self.initScroll()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boyImages.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! URExampleTableViewCell

        cell.configView(image: self.boyImages[indexPath.row], text: self.boyTexts[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    var preOffsetY: CGFloat = 0.0
    var preOffsetY1: CGFloat = 0.0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("tableView's scrollView is \(scrollView), self.scrollView is \(self.scrollView), self.scrollView1 is \(self.scrollView1)")

//        let scrollDirection: URScrollVerticalDirection = self.preOffsetY > scrollView.contentOffset.y ? .down : .up

        let scrollRatio: CGFloat = self.scrollView.contentSize.height / scrollView.contentSize.height * self.parallaxScrollRatio
        let limitImageScrollOffsetY: CGFloat = self.refreshImageView.bounds.height + abs(scrollView.contentOffset.y * scrollRatio)

        let scrollRatio1: CGFloat = self.scrollView1.contentSize.height / scrollView.contentSize.height * self.parallaxScrollRatio1

        let progress: CGFloat = abs(scrollView.contentOffset.y) / limitImageScrollOffsetY
        if limitImageScrollOffsetY > abs(scrollView.contentOffset.y) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y * scrollRatio)
            self.scrollView1.contentOffset = CGPoint(x: 0, y: self.preOffsetY1 + (scrollView.contentOffset.y * scrollRatio1 * -1))

            self.generateHapticFeedback()

            self.animateRefreshImage(progress: progress)
        } else {
            self.isHapticFeedbackEnabled = false

            self.animateRefreshImage(progress: 1.0)

            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetY))
            self.scrollView1.contentOffset = CGPoint(x: 0, y: self.scrollView1.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetY))
        }

        self.preOffsetY = scrollView.contentOffset.y

        print("moved is \(scrollView.contentOffset.y * scrollRatio)")

        if scrollView.contentOffset.y == 0 {
            self.initScroll()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isHapticFeedbackEnabled = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isHapticFeedbackEnabled = false

        self.animateRefreshImage(progress: 0.0)
    }

    var isHapticFeedbackEnabled: Bool = true

    func generateHapticFeedback() {
        if self.isHapticFeedbackEnabled {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }

    func animateRefreshImage(progress: CGFloat) {
        self.lotAnimationView.animationProgress = progress
    }
}

enum URScrollVerticalDirection {
    case up
    case down
}

func roundUp(_ value: Double, roundUpPosition: Int) -> Double {
    let roundUpPositionBy10 = pow(10.0, Double(roundUpPosition))
    return round(value * roundUpPositionBy10) / roundUpPositionBy10
}
