/// Copyright (c) 2019 Razeware LLC
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

class  TwitterLiteSearchbar: UISearchBar {
  private let color = UIColor(red: 255.0/255.0, green: 126.0/255.0, blue: 121.0/255.0, alpha: 1)
  private let image = UIImage(named: "clear")

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.layer.borderWidth = 1
    self.layer.borderColor = color.cgColor
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
    guard let iconView = textField.leftView as? UIImageView  else { return }
    iconView.image = iconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    iconView.tintColor = color

    guard let clearButton = textField.value(forKey: "clearButton") as? UIButton else { return }
    update(button: clearButton, image: image, color: color)
  }

  private func update(button: UIButton, image: UIImage?, color: UIColor) {
    let image = (image ?? button.currentImage)?.withRenderingMode(.alwaysTemplate)
    button.setImage(image, for: .normal)
    button.setImage(image, for: .highlighted)
    button.tintColor = color
  }
}
