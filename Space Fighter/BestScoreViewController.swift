//
//  BestScoreViewController.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 8/3/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import UIKit

class BestScoreViewController: UIViewController {

    var VCIDs : [String] = ["BestScoreEasy", "BestScoreMedium", "BestScoreHard"]
    var buttonTitles : [String] = ["Easy", "Medium", "Hard"]

    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swiftPagesView : SwiftPages!
        swiftPagesView = SwiftPages(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.view.addSubview(swiftPagesView)
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
        swiftPagesView.setAnimatedBarColor(UIColor.redColor())
        swiftPagesView.setTopBarBackground(UIColor(red:0.17, green:0.16, blue:0.18, alpha:1.0))
        swiftPagesView.setButtonsTextColor(UIColor.redColor())
        swiftPagesView.setButtonsTextFontAndSize(UIFont(name: "VCR OSD Mono", size: 20)!)
        
        self.view.addSubview(closeButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
