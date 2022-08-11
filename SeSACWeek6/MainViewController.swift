//
//  MainViewController.swift
//  SeSACWeek6
//
//  Created by 이중원 on 2022/08/09.
//

import UIKit

import Kingfisher

/*
 tableView - CollectionView > 프로토콜
 tag
 */
/*
 awakeFromNib - 셀 UI 초기화, 재사용 메커니즘에 의해 일정 횟수 이상 호출되지 않음
 cellForItemAt
 - 재사용 될 때마다, 사용자에게 보일 때 마다 항상 실행됨
 //화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음
 prepareForReuse
 - 셀이 재사용 될 때 초기화하고자 하는 값을 넣으면 오류를 해결할 수 있음. 즉, cellForRowAt에서 모든 indexPath.item에 대한 조건을 작성하지 않아도 됨!
 CollectionView in TableView
 - 하나의 컬렉션뷰나 테이블뷰라면 문제 x
 - 복합적인 구조라면, 테이블셀도 재사용 되어야 하고 컬렉션셀도 재사용이 되어야 함
 - Index > releadData
 
 - 문제 찾는 방식: print, Debug 등을 이용
 */

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    let color: [UIColor] = [.red, .purple, .lightGray, .yellow, .black]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](51...60),
        [Int](61...70),
        [Int](71...80),
        [Int](81...90)
    ]
    
    var episodeList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainTableView.delegate = self
        mainTableView.dataSource = self

        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true //스크롤이 자석처럼 붙는 느낌..! //cell 기준이 아니라 device width 기준 => cell의 너비를 device의 너비와 맞춰줘야 자연스럽다
        
        TMDBAPIManager.shared.requestImage { posterList in
            dump(posterList)
            //1.네트워크 통신 2.배열 생성 3.배열에 요소 담기
            //4.뷰 등에 표현
                // ex. 테이블뷰 섹션, 컬렉션뷰 셀
            //5.뷰 갱신!
            self.episodeList = posterList
            self.mainTableView.reloadData()
        }
        
    }
    
}

//하나의 프로토콜, 메서드에서 여러 컬렉션뷰의 delegate, datasource 구현해야 함
//UICollectionViewDelegateFlowLayout - sizeForItemAt - 역동적인 셀
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    //bannerCoolectionView OR 테이블뷰 안에 들어있는 컬렉션뷰
    //내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀이 재사용되면 특정 collectionView 셀을 재사용하게 될 수 있음
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("MainViewController", #function, indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.row]
            cell.cardView.contentLabel.text = "Netflix"
            cell.cardView.contentLabel.textColor = .white
        } else {
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.contentLabel.textColor = .white
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.posterImageView.kf.setImage(with: url)
            cell.cardView.contentLabel.text = nil
            
            //화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음
//            if indexPath.item < 2 {
//            cell.cardView.contentLabel.text = String(numberList[collectionView.tag][indexPath.item])
//            }
//            else {
//                cell.cardView.contentLabel.text = "HAPPY"
//            }
        }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //내부 매개변수 tableView를 통해 테이블뷰를 특정
    //테이블뷰 객체가 하나일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell() }
        
        print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.tag = indexPath.section //각 셀 구분짓기!
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        cell.titleLabel.text = "\(TMDBAPIManager.shared.tvList[indexPath.section].0) 드라마 다시보기"
        
        cell.contentCollectionView.reloadData() //Index Out of Range
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
}

