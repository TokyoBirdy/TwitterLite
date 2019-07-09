/// Copyright (c) 1 Reiwa Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class TwitterLiteViewController: UIViewController {

  var backend:[Tweet] = []
  var tweets: [Tweet] = []
  let tweetLimit = 2
  var initialTweet = 0
  let initialText = ""
  var searchText = ""


  @IBOutlet var tableView: UITableView!


  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialLoad()
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    initialLoad()
  }

  private func initialLoad() {
    if let path = Bundle.main.path(forResource: "Tweet", ofType: "json") {
      let pathURL = URL(fileURLWithPath: path)
      do {
        let data = try Data(contentsOf: pathURL)
        backend = try JSONDecoder().decode([Tweet].self, from: data)
      } catch {
        dump(error)
        backend = []
      }
    } else {
      backend = []
    }
  }

  override func viewDidLoad() {
    searchText = initialText
    super.viewDidLoad()
    try? loadData(withText: searchText, count: tweetLimit)
  }

  private func loadData(withText text: String, count count: Int) throws {
    // mimic the behaviour of sending backend request each time
    //TODO: fake the request

    // Get back with response

    //Need to fix the count
    tweets = backend.compactMap{ tweet in
      return tweet.text.contains(text) ? tweet: nil }
    refreshView(withData: tweets)
  }

  private func refreshView(withData tweets: [Tweet]) {
    tableView.reloadData()
  }



}

extension TwitterLiteViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
    cell.textLabel?.text = tweets[indexPath.row].text
    return cell
  }
}

extension TwitterLiteViewController: UISearchBarDelegate {

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("end")
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    do {
      try loadData(withText: searchBar.text ?? "", count: tweetLimit )
    } catch {
      dump(error)
    }

    print("click search")
  }
}
