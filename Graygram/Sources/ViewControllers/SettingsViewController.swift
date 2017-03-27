//
//  SettingsViewController.swift
//  Graygram
//
//  Created by aney on 2017. 3. 27..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import SafariServices
import UIKit

// UIWebView : 이제 안씀
// WKWebView: UIView 새 버전, 현재 씀
// SFSafariViewController: UIViewController

final class SettingsViewController: UIViewController {
  
  // Section Model
  
  struct Section {
    var items: [SectionItem]
  }
  
  enum SectionItem {
    case about
    case openSourceLicense
    case icons
    case version
    case logout
  }
  
  struct CellData {
    var text: String
    var detailText: String?
  }
  
  fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
  var didSetupConstraints = false
  
  fileprivate var sections: [Section] = [
    Section(items: [.about, .openSourceLicense, .icons]),
    Section(items: [.version]),
    Section(items: [.logout]),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Settings"
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(SettingCell.self, forCellReuseIdentifier: "cell")
    self.view.addSubview(self.tableView)
    self.view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !self.didSetupConstraints {
      self.didSetupConstraints = true
      self.tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
    super.updateViewConstraints()
  }
  
  func cellData(for sectionItem: SectionItem) -> CellData {
    switch sectionItem {
    case .about:
      return CellData(text: "Graygram에 관하여", detailText: nil)
      
    case .openSourceLicense:
      return CellData(text: "오픈소스 라이센스", detailText: nil)
      
    case .icons:
      return CellData(text: "아이콘 출처", detailText: "icons8.com")
      
    case .version:
      let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
      return CellData(text: "현재 버전", detailText: version)
      
    case .logout:
      return CellData(text: "로그 아웃", detailText: nil)
    }
  }
  
}

extension SettingsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections[section].items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let sectionItem = self.sections[indexPath.section].items[indexPath.row]
    let cellData = self.cellData(for: sectionItem)
    cell.textLabel?.text = cellData.text
    cell.detailTextLabel?.text = cellData.detailText
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
}

extension SettingsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let sectionItem = self.sections[indexPath.section].items[indexPath.row]
    switch sectionItem {
    case .about:
      break
      
    case .openSourceLicense:
      break
      
    case .icons:
      let url = URL(string: "https://icons8.com")!
      let viewController = SFSafariViewController(url: url)
      self.present(viewController, animated: true, completion: nil)
      
    case .version:
      break
      
    case .logout:
      AuthService.logout()
      AppDelegate.instance?.presentLoginScreen()
    }
  }
  
}


final class SettingCell: UITableViewCell {
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
