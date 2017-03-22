//
//  FeedViewController.swift
//  Graygram
//
//  Created by aney on 2017. 2. 22..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
	
	// MARK: Properties
	
	var posts: [Post] = []
	var nextURLString: String?
	var isLoading: Bool = false
	
	
	// MARK: UI
	
	let refreshControl = UIRefreshControl()
	let collectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: UICollectionViewFlowLayout()
	)
  
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.tabBarItem.title = "Feed"
    //title을 설정하면, 네비게이션 바, 탭 바 제목이 된다.
    //각 각 따로 지정도 가능, tabBarItem.title , navigationItem.title
    self.tabBarItem.image = UIImage(named: "tab-feed")
    self.tabBarItem.selectedImage = UIImage(named: "tab-feed-selected")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
	
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.refreshControl.addTarget(self, action: #selector(refreshControlDidChangeValue), for: .valueChanged)
		self.collectionView.backgroundColor = .white
		self.collectionView.frame = self.view.bounds
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.collectionView.register(PostCardCell.self, forCellWithReuseIdentifier: "postCell")
		self.collectionView.register(
			CollectionActivityIndicatorView.self,
			forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
			withReuseIdentifier: "activityIndicatorView"
		)
		self.view.addSubview(collectionView)
		self.collectionView.addSubview(refreshControl)
		
		self.collectionView.snp.makeConstraints { make in
			
			make.edges.equalToSuperview()
			//auto layout은 굉장히 느리다. 가급적 cell에는 쓰지 말 것.
			//image cornetradius 값 주는 것도 굉장히 느리다. 마스킹 로직이 무겁기 때문
			//이미지를 두개 올린다. masking image, 원본 이미지
			//리소스는 2x, 3x로만 준비하면 된다. 개발시엔 1x로
			
		}
		
		self.refreshControlDidChangeValue()
    
    NotificationCenter.default.addObserver(self, selector: #selector(postDidLike), name: .postDidLike, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(postDidUnlike), name: .postDidUnlike, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(postDidCreate), name: .postDidCreate, object: nil)
	}
  
  deinit {
    NotificationCenter.default.removeObserver(self) //옵저버 전부 해제
  }
	
	fileprivate dynamic func refreshControlDidChangeValue() {
    self.loadFeed(paging: .refresh)
	}

  func loadFeed(paging: Paging) {
		// 중복 로딩 방지
		guard !self.isLoading else { return }
		self.isLoading = true
    
    FeedService.feed(paging: paging) { response in
      self.isLoading = false
      self.refreshControl.endRefreshing()
      
      switch response.result {
      case .success(let feed):
        switch paging {
        case .refresh:
          self.posts = feed.posts
          
        case .next:
          self.posts.append(contentsOf: feed.posts)
        }
        self.nextURLString = feed.nextURLString
        self.collectionView.reloadData()
        
      case .failure(let error):
        print("피드 요청 실패: \(error)")
      }
    }
	}
  
  
  // MARK: Notifications
  
  func postDidLike(notification: Notification) {
    guard let postID = notification.userInfo?["postID"] as? Int else { return }
    for (i, post) in self.posts.enumerated() {
      if post.id == postID {
        var newPost = post
        newPost.isLiked = true
        newPost.likeCount? += 1
        self.posts[i] = newPost
        self.collectionView.reloadData()
        break
      }
    }
  }
  
  func postDidUnlike(notification: Notification) {
    guard let postID = notification.userInfo?["postID"] as? Int else { return }
    for (i, post) in self.posts.enumerated() {
      if post.id == postID {
        var newPost = post
        newPost.isLiked = false
        newPost.likeCount? -= 1
        self.posts[i] = newPost
        self.collectionView.reloadData()
        break
      }
    }
  }
  
  func postDidCreate(notification: Notification) {
    guard let post = notification.userInfo?["post"] as? Post else { return }
    
    self.posts.insert(post, at: 0)
    self.collectionView.reloadData()
  }
}


//MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.posts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell",
		                                              for: indexPath
		) as! PostCardCell
		
		let post = self.posts[indexPath.item]
		cell.configure(post: post)
		return cell
	}
	
	//MARK: CollectionView Supplementary..
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let view = collectionView.dequeueReusableSupplementaryView(
			ofKind: UICollectionElementKindSectionFooter,
			withReuseIdentifier: "activityIndicatorView",
			for: indexPath
		)
		
		return view
	}
	
}


//MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
	
	//더보기 기능 구현 
	//MARK: UIScrollView
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		print(scrollView.contentOffset.y + scrollView.height, scrollView.contentSize)
		//contentOffset은 기준이 top이기 때문에 값이 contentSize 보다 작다.
		let scrollBottom = scrollView.contentOffset.y + scrollView.height
		let scrollHeight = scrollView.contentSize.height
		
    if let nextURLString = self.nextURLString,
      scrollBottom >= scrollHeight - 200 && scrollView.contentSize.height > 0 {
      self.loadFeed(paging: .next(nextURLString))
    }
  }
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let post = self.posts[indexPath.item]
		return PostCardCell.size(width: collectionView.width, post: post)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 15
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		if self.nextURLString == nil && !self.posts.isEmpty {
			return CGSize(width: collectionView.width, height: 0)
		} else {
			return CGSize(width: collectionView.width, height: 44)
		}
	}
}
