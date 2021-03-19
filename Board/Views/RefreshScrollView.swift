//
//  RefreshScrollView.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI

struct RefreshScrollView<Content: View>: UIViewControllerRepresentable {
    @Binding var isRefreshing: Bool
    let content: () -> Content
    let hostingController = UIHostingController(rootView: AnyView(EmptyView()))

    init(isRefreshing: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        _isRefreshing = isRefreshing
        self.content = content
    }

    func makeUIViewController(context: Context) -> RefreshViewController {
        let controller = RefreshViewController()
        controller.onRefreshChanged = { isRefreshing in
            guard self.isRefreshing != isRefreshing else { return }
            self.isRefreshing = isRefreshing
        }

        hostingController.rootView = AnyView(content())
        controller.contentController = hostingController
        return controller
    }

    func updateUIViewController(_ viewController: RefreshViewController, context: Context) {
        hostingController.rootView = AnyView(content())
        viewController.toggleRefreshControl(isRefreshing: isRefreshing)
    }
}

final class RefreshViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateRefreshControl), for: .valueChanged)
        view.refreshControl = refreshControl

        return view
    }()

    var onRefreshChanged: ((Bool) -> Void)?
    var contentController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let contentController = self.contentController,
              contentController.view.frame.height > 0 else {
            return
        }

        contentController.view.setNeedsUpdateConstraints()
    }

    func toggleRefreshControl(isRefreshing: Bool) {
        if isRefreshing {
            scrollView.refreshControl?.beginRefreshing()
        } else {
            scrollView.refreshControl?.endRefreshing()
        }
    }

    private func configureContent() {
        view.addSubview(scrollView)
        guard let contentController = contentController else { return }
        addChild(contentController)
        view.addSubview(contentController.view)
        contentController.didMove(toParent: self)
        scrollView.addSubview(contentController.view)
    }

    func configureConstraints() {
        guard let contentController = contentController else { return }
        scrollView.pinToEdges(of: view)
        contentController.view.pinToEdges(of: scrollView)

        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(greaterThanOrEqualTo: contentController.view.widthAnchor)
        ])
    }

    @objc private func updateRefreshControl(sender: UIRefreshControl) {
        onRefreshChanged?(sender.isRefreshing)
    }
}

struct RefreshScrollView_Previews: PreviewProvider {
    struct StateWrapper: View {
        @State var isRefreshing = false

        var body: some View {
            RefreshScrollView(isRefreshing: self.$isRefreshing) {
                ForEach(0..<100) { index in
                    HStack {
                        Text("Item #\(index)")
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemFill))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
            .edgesIgnoringSafeArea(.vertical)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isRefreshing = false
                }
            }
        }
    }
    static var previews: some View {
        StateWrapper()
    }
}

private extension UIView {
    func pinToEdges(of view: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
    }
}
