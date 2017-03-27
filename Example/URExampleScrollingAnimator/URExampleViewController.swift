//
//  ViewController.swift
//  URExampleScrollingAnimator
//
//  Created by DongSoo Lee on 2017. 3. 27..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

let DefaultParallexScrollRatio: CGFloat = 2.0

class URExampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var refreshImageView: UIImageView!

    @IBOutlet var slParallexScrollRatio: UISlider!
    @IBOutlet var lbParallexScrollRatioMin: UILabel!
    @IBOutlet var lbParallexScrollRatioMax: UILabel!
    @IBOutlet var lbParallexScrollRatioCurrent: UILabel!

    @IBOutlet var btnInitRatio: UIButton!

    var parallexScrolRatio: CGFloat = DefaultParallexScrollRatio {
        didSet {
            self.lbParallexScrollRatioCurrent.text = "\(self.parallexScrolRatio)"
        }
    }

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

    func initView() {
        self.btnInitRatio.layer.cornerRadius = 5.0

        self.lbParallexScrollRatioMin.text = "\(self.slParallexScrollRatio.minimumValue)"
        self.lbParallexScrollRatioMax.text = "\(self.slParallexScrollRatio.maximumValue)"
        self.lbParallexScrollRatioCurrent.text = "\(self.slParallexScrollRatio.value)"
    }

    @IBAction func tapInitRatio(_ sender: Any) {
        self.parallexScrolRatio = DefaultParallexScrollRatio
        self.slParallexScrollRatio.value = Float(DefaultParallexScrollRatio)
    }

    @IBAction func changeParallexScrollRatio(_ sender: Any) {
        let value = roundUp(Double(self.slParallexScrollRatio.value), roundUpPosition: 2)
        self.parallexScrolRatio = CGFloat(value)
        self.slParallexScrollRatio.setValue(Float(value), animated: false)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView)")

        let scrollRatio: CGFloat = self.scrollView.contentSize.height / scrollView.contentSize.height * self.parallexScrolRatio
        let limitImageScrollOffsetY: CGFloat = self.refreshImageView.bounds.height + abs(scrollView.contentOffset.y * scrollRatio)
        if limitImageScrollOffsetY > abs(scrollView.contentOffset.y) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y * scrollRatio)
        } else {
            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetY))
        }

        self.preOffsetY = scrollView.contentOffset.y

        print("moved is \(scrollView.contentOffset.y * scrollRatio)")
    }
}

func roundUp(_ value: Double, roundUpPosition: Int) -> Double {
    let roundUpPositionBy10 = pow(10.0, Double(roundUpPosition))
    return round(value * roundUpPositionBy10) / roundUpPositionBy10
}
