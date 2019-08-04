//
//  MenuViewController.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 15/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Parchment
import ARKit

class MenuViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var pagingSubMenuContainerViewController: UIView!
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sceneView: ARSCNView!

    private var currentFoodNode: SCNNode?
    
    private let pagingViewController = SubMenuPagingViewController()
    
    private let menuInsets = UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18)
    private let menuItemSize = CGSize(width: 100, height: 80)
    
    private var menuHeight: CGFloat {
        return menuItemSize.height + menuInsets.top + menuInsets.bottom
    }
    
    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: UIView.AnimationCurve.easeInOut, animations: nil)
    private var blurEffectView: UIVisualEffectView!
    
    private var isMenuCollapsed: Bool {
        return pagingSubMenuContainerViewController.frame.minY >= self.view.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupARConfiguration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        setupVisualEffectView()
        setupPagingSubMenuContainerVC()
        setupPagingVC()
        setupSubPagingMenuWithPagingVC()
    }
    
    @objc func menuWasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            if gestureRecognizer.velocity(in: pagingSubMenuContainerViewController).y >= 2250 {
                collapseMenu()
            } else if gestureRecognizer.velocity(in: pagingSubMenuContainerViewController).y <= -2250 {
                expandMenu()
            }
            
            let translation = gestureRecognizer.translation(in: self.view)
            updateAnimatorFromGestureTranslation(translation, gesture: gestureRecognizer)
        } else if gestureRecognizer.state == .ended {
            if isMenuCollapsed {
                collapseMenu()
            } else {
                expandMenu()
            }
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func collapseMenu() {
        self.menuHeightConstraint.constant = 350
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseInOut, .allowUserInteraction], animations: {
            self.animator.fractionComplete = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func expandMenu() {
        self.menuHeightConstraint.constant = self.view.frame.height-80
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseInOut, .allowUserInteraction], animations: {
            self.animator.fractionComplete = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func updateAnimatorFromGestureTranslation(_ translation: CGPoint, gesture: UIPanGestureRecognizer) {
        if gesture.view!.center.y < self.view.frame.height-50 {
            menuHeightConstraint.constant -= translation.y
            animator.fractionComplete -= translation.y/400
        } else {
            menuHeightConstraint.constant = 350
            animator.fractionComplete = 0
        }
        
        gesture.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
}

private extension MenuViewController {
    func setupARConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.antialiasingMode = .multisampling4X
        
        sceneView.session.run(configuration)
    }
    
    func setupSceneView() {
        currentFoodNode = SCNFoodModel.pie
        sceneView.delegate = self
    }
    
    func setupVisualEffectView() {
        blurEffectView = UIVisualEffectView()
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(blurEffectView)
        self.view.bringSubviewToFront(pagingSubMenuContainerViewController)
        
        animator.addAnimations {
            self.blurEffectView.effect = UIBlurEffect(style: .regular)
        }
    }
    
    func setupPagingSubMenuContainerVC() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(menuWasDragged(gestureRecognizer:)))
        gesture.delegate = self
        
        pagingSubMenuContainerViewController.addGestureRecognizer(gesture)
        pagingSubMenuContainerViewController.isUserInteractionEnabled = true
    }
    
    func setupPagingVC() {
        pagingViewController.menuItemSource = .class(type: SubMenuImagePagingCell.self)
        pagingViewController.menuItemSize = .fixed(width: menuItemSize.width, height: menuItemSize.height)
        pagingViewController.menuItemSpacing = 10
        pagingViewController.menuInsets = menuInsets
        pagingViewController.borderColor = UIColor(white: 0, alpha: 0.1)
        pagingViewController.indicatorColor = .darkGray
        pagingViewController.view.alpha = 0.90
        
        pagingViewController.view.layer.shadowColor = UIColor.darkGray.cgColor
        pagingViewController.view.layer.shadowOpacity = 1
        pagingViewController.view.layer.shadowOffset = .zero
        pagingViewController.view.layer.shadowRadius = 10
        
        pagingViewController.indicatorOptions = .visible(
            height: 1,
            zIndex: Int.max,
            spacing: UIEdgeInsets.zero,
            insets: UIEdgeInsets.zero
        )
        
        pagingViewController.borderOptions = .visible(
            height: 1,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        )
        
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        
        addChild(pagingViewController)
    }
    
    func setupSubPagingMenuWithPagingVC() {
        pagingSubMenuContainerViewController.addSubview(pagingViewController.view)
        pagingSubMenuContainerViewController.constrainToEdges(pagingViewController.view)
        
        pagingViewController.didMove(toParent: self)
        pagingViewController.select(pagingItem: subMenuItems[0])
    }
    
    func calculateMenuHeight(for scrollView: UIScrollView) -> CGFloat {
        let maxChange: CGFloat = 50
        let offset = min(maxChange, scrollView.contentOffset.y + menuHeight) / maxChange
        let height = menuHeight - (offset * maxChange)
        return height
    }
    
    func updateMenu(height: CGFloat) {
        guard let menuView = pagingViewController.view as? SubMenuPagingView else { return }
        menuView.menuHeightConstraint?.constant = height
        
        pagingViewController.menuItemSize = .fixed(
            width: menuItemSize.width,
            height: height - menuInsets.top - menuInsets.bottom
        )
        
        pagingViewController.collectionViewLayout.invalidateLayout()
        pagingViewController.collectionView.layoutIfNeeded()
    }
}

extension MenuViewController: PagingViewControllerDataSource {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        let viewController = SubMenuViewController(
            foods: subMenuItems[index].foods,
            options: pagingViewController.options
        )
        
        viewController.delegate = self
        
        let insets = UIEdgeInsets(top: menuHeight, left: 0, bottom: 0, right: 0)
        viewController.collectionView.contentInset = insets
        viewController.collectionView.scrollIndicatorInsets = insets
        
        return viewController
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return subMenuItems[index] as! T
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int{
        return subMenuItems.count
    }
}

extension MenuViewController: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, isScrollingFromItem currentPagingItem: T, toItem upcomingPagingItem: T?, startingViewController: UIViewController, destinationViewController: UIViewController?, progress: CGFloat) {
        guard let destinationViewController = destinationViewController as? SubMenuViewController else { return }
        guard let startingViewController = startingViewController as? SubMenuViewController else { return }
        
        let from = calculateMenuHeight(for: startingViewController.collectionView)
        let to = calculateMenuHeight(for: destinationViewController.collectionView)
        let height = ((to - from) * abs(progress)) + from
        updateMenu(height: height)
    }
}

extension MenuViewController: ImagesViewControllerDelegate {
    func imagesViewControllerDidScroll(_ imagesViewController: SubMenuViewController) {
        let height = calculateMenuHeight(for: imagesViewController.collectionView)
        updateMenu(height: height)
    }
    
    func foodWasSelected(_ food: Food) {
        guard let hit = sceneView.hitTest(self.view.center, types: [.existingPlaneUsingExtent]).first else { return }
        
        currentFoodNode!.position = SCNVector3(hit.worldTransform.translation.x, hit.worldTransform.translation.y+0.02, hit.worldTransform.translation.z-0.1)
        sceneView.scene.rootNode.addChildNode(currentFoodNode!)
        
        if !isMenuCollapsed {
            collapseMenu()
        }
    }
}

extension MenuViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let plane = anchor as? ARPlaneAnchor, let nodeModel = currentFoodNode else {
            node.removeFromParentNode()
            return
        }
        
        let extent = plane.extent
        let planeGeometery = SCNPlane(width: CGFloat(extent.x+0.5), height: CGFloat(extent.z+0.5))
        planeGeometery.firstMaterial?.colorBufferWriteMask = []
        planeGeometery.firstMaterial?.isDoubleSided = true
        
        let planeNode = nodeModel.childNode(withName: "plane", recursively: false)!
        planeNode.renderingOrder = -1
        planeNode.geometry = planeGeometery
        
        let center = plane.center
        planeNode.position = SCNVector3Make(center.x, -6.2, center.z)
    }
}
