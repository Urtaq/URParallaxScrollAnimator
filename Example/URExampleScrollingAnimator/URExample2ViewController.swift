//
//  URExample2ViewController.swift
//  URExampleScrollingAnimator
//
//  Created by DongSoo Lee on 2017. 4. 5..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import URParallaxScrollAnimator

class URExample2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    @IBOutlet var slParallexScrollRatio: UISlider!
    @IBOutlet var lbParallexScrollRatioMin: UILabel!
    @IBOutlet var lbParallexScrollRatioMax: UILabel!
    @IBOutlet var lbParallexScrollRatioCurrent: UILabel!

    @IBOutlet var btnInitRatio: UIButton!

    @IBOutlet var swEnableHapticFeedback: UISwitch!
    @IBOutlet var swEnablePullToRefresh: UISwitch!

    var girlImages: [UIImage] = [#imageLiteral(resourceName: "suzy1"), #imageLiteral(resourceName: "suzy2"), #imageLiteral(resourceName: "suzy3"), #imageLiteral(resourceName: "suzy4"), #imageLiteral(resourceName: "seolhyun1"), #imageLiteral(resourceName: "seolhyun2"), #imageLiteral(resourceName: "seolhyun3"), #imageLiteral(resourceName: "seolhyun4")]
    var girlTexts: [String] = ["Suzy in korean transitional dress", "Suzy during an interview", "Smiling Suzy", "Brightly Smiling Suzy", "SeolHyun wearing a swimming suit", "SeolHyun standing nicely", "SeolHyun carrying a cute bag", "SeolHyun laying down"]

    var boyImages: [UIImage] = [#imageLiteral(resourceName: "seokangjun1"), #imageLiteral(resourceName: "seokangjun2"), #imageLiteral(resourceName: "joinsung1"), #imageLiteral(resourceName: "joinsung2"), #imageLiteral(resourceName: "joinsung3"), #imageLiteral(resourceName: "gosu1"), #imageLiteral(resourceName: "gosu2"), #imageLiteral(resourceName: "jungwoosung1"), #imageLiteral(resourceName: "jungwoosung2"), #imageLiteral(resourceName: "jongsuk1"), #imageLiteral(resourceName: "seokangjun1"), #imageLiteral(resourceName: "seokangjun2"), #imageLiteral(resourceName: "joinsung1"), #imageLiteral(resourceName: "joinsung2"), #imageLiteral(resourceName: "joinsung3"), #imageLiteral(resourceName: "gosu1"), #imageLiteral(resourceName: "gosu2"), #imageLiteral(resourceName: "jungwoosung1"), #imageLiteral(resourceName: "jungwoosung2"), #imageLiteral(resourceName: "jongsuk1"), #imageLiteral(resourceName: "seokangjun1"), #imageLiteral(resourceName: "seokangjun2"), #imageLiteral(resourceName: "joinsung1"), #imageLiteral(resourceName: "joinsung2"), #imageLiteral(resourceName: "joinsung3"), #imageLiteral(resourceName: "gosu1"), #imageLiteral(resourceName: "gosu2"), #imageLiteral(resourceName: "jungwoosung1"), #imageLiteral(resourceName: "jungwoosung2"), #imageLiteral(resourceName: "jongsuk1"), #imageLiteral(resourceName: "seokangjun1"), #imageLiteral(resourceName: "seokangjun2"), #imageLiteral(resourceName: "joinsung1"), #imageLiteral(resourceName: "joinsung2"), #imageLiteral(resourceName: "joinsung3"), #imageLiteral(resourceName: "gosu1"), #imageLiteral(resourceName: "gosu2"), #imageLiteral(resourceName: "jungwoosung1"), #imageLiteral(resourceName: "jungwoosung2"), #imageLiteral(resourceName: "jongsuk1")]
    var boyTexts: [String] = ["KangJun with 'V'", "KangJun in suit", "InSung's face at the left side", "InSung is looking at me", "Dandy InSung", "GoSu", "GoSu with scarf", "WooSung in suit", "WooSung is looking at somewhere", "JongSuk is smiling", "KangJun with 'V'", "KangJun in suit", "InSung's face at the left side", "InSung is looking at me", "Dandy InSung", "GoSu", "GoSu with scarf", "WooSung in suit", "WooSung is looking at somewhere", "JongSuk is smiling", "KangJun with 'V'", "KangJun in suit", "InSung's face at the left side", "InSung is looking at me", "Dandy InSung", "GoSu", "GoSu with scarf", "WooSung in suit", "WooSung is looking at somewhere", "JongSuk is smiling", "KangJun with 'V'", "KangJun in suit", "InSung's face at the left side", "InSung is looking at me", "Dandy InSung", "GoSu", "GoSu with scarf", "WooSung in suit", "WooSung is looking at somewhere", "JongSuk is smiling"]

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

        self.tableView.parallaxScrollExtension.makeParallaxScrollExtensionConfiguration(upperImage: #imageLiteral(resourceName: "cloud_by_ur2"), lowerImage: #imageLiteral(resourceName: "mountain_by_ur2"), lowerLottieData: nil)
        self.tableView.parallaxScrollExtension.refreshAction = {
            let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            let backView: UIView = UIView(frame: self.tableView.frame)
            backView.addSubview(indicatorView)
            indicatorView.center = backView.center
            self.view.addSubview(backView)
            backView.backgroundColor = UIColor(white: 0.5, alpha: 0.1)
            indicatorView.startAnimating()

            let timer: Timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] (_) in
                guard let wself = self else { return }
                wself.tableView.parallaxScrollExtension.parallaxScrollViewDidPullToRefresh()
                backView.removeFromSuperview()
            })

            RunLoop.main.add(timer, forMode: .commonModes)
        }
        self.tableView.parallaxScrollExtension.configuration.isEnabledPullToRefresh = self.swEnablePullToRefresh.isOn

        self.initValues()
    }

    func initValues() {
        self.slParallexScrollRatio.value = Float(URParallaxScrollConfiguration.DefaultParallaxScrollRatio)
        self.lbParallexScrollRatioCurrent.text = "\(URParallaxScrollConfiguration.DefaultParallaxScrollRatio)"

        self.tableView.parallaxScrollExtension.configuration.parallaxScrollRatio = URParallaxScrollConfiguration.DefaultParallaxScrollRatio
        self.tableView.parallaxScrollExtension.initScroll()
        self.tableView.parallaxScrollExtension.parallaxScrollViewDidPullToRefresh()
    }

    @IBAction func tapInitRatio(_ sender: Any) {
        self.initValues()
    }

    @IBAction func changeParallexScrollRatio(_ sender: Any) {
        let value = roundUp(Double(self.slParallexScrollRatio.value), roundUpPosition: 2)
        self.slParallexScrollRatio.setValue(Float(value), animated: false)
        self.lbParallexScrollRatioCurrent.text = "\(value)"

        self.tableView.parallaxScrollExtension.configuration.parallaxScrollRatio = CGFloat(value)
    }

    @IBAction func switchEnableHapticFeedback(_ sender: Any) {
        self.tableView.parallaxScrollExtension.configuration.isEnabledHapticFeedback = self.swEnableHapticFeedback.isOn
    }

    @IBAction func switchEnablePullToRefresh(_ sender: Any) {
        self.tableView.parallaxScrollExtension.configuration.isEnabledPullToRefresh = self.swEnablePullToRefresh.isOn
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

        self.tableView.parallaxScrollExtension.parallaxScrollViewDidPullToRefresh()
    }

    // MARK:- URParallaxScrollDelegate
    var preOffsetY: CGFloat = 0.0
    var preOffsetY1: CGFloat = 0.0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableView.parallaxScrollExtension.parallaxScrollViewDidScroll(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.parallaxScrollExtension.parallaxScrollViewWillBeginDragging(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.tableView.parallaxScrollExtension.parallaxScrollViewDidEndDragging(scrollView)
    }
}

func roundUp(_ value: Double, roundUpPosition: Int) -> Double {
    let roundUpPositionBy10 = pow(10.0, Double(roundUpPosition))
    return round(value * roundUpPositionBy10) / roundUpPositionBy10
}
