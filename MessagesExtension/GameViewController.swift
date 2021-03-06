import UIKit
import SpriteKit

protocol GameViewControllerDelegate: class {
    func didFinishMove(setupValue: String,
                       boardSizeValue: String,
                       activePieceSetValue: String,
                       backwardJumpsValue: String,
                       backwardJumpsInSequencesValue: String,
                       mandatoryCapturingValue: String,
                       snapshot gameSnapshot: UIImage)
}

class GameViewController: UIViewController {
    static let storyboardIdentifier = "GameViewController"

    weak var delegate: GameViewControllerDelegate?

    var scene: GameScene!
    var board: Board!
    var skView: SKView!

    @IBOutlet weak var boardView: UIView!

    @IBOutlet weak var activePieceSetImage: UIImageView! {
        didSet {
            activePieceSetImage.image = board.activePieceSet.symbolImage
        }
    }

    @IBOutlet weak var mandatoryCaptureLabel: UILabel! {
        didSet {
            mandatoryCaptureLabel.isHidden = true
        }
    }

    @IBOutlet weak var helpMandatoryCapturingLabel: UILabel! {
        didSet {
            if board.mandatoryCapturing {
                helpMandatoryCapturingLabel.text = "- Capturing is mandatory"
            } else {
                helpMandatoryCapturingLabel.text = "- Capturing is optional"
            }
        }
    }

    @IBOutlet weak var helpBackwardJumpsLabel: UILabel! {
        didSet {
            if board.backwardJumps {
                helpBackwardJumpsLabel.text = "- Backward jumps are allowed"
            } else {
                helpBackwardJumpsLabel.text = "- Backward jumps are forbidden"
            }
        }
    }

    @IBOutlet weak var helpBackwardJumpsInSequencesLabel: UILabel! {
        didSet {
            if board.backwardJumpsInSequences {
                helpBackwardJumpsInSequencesLabel.text = "- Backward jumps are allowed in sequences (the second, third etc. jump with the same piece)"
            } else {
                helpBackwardJumpsInSequencesLabel.text = "- Backward jumps are forbidden in sequences (the second, third etc. jump with the same piece)"
            }
        }
    }

    @IBOutlet weak var helpView: UIView! {
        didSet {
            helpView.isHidden = true
        }
    }

    @IBAction private func tapHelpButton() {
        helpView.alpha = 0.0
        helpView.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: { self.helpView.alpha = 1.0 },
                       completion: nil)
    }

    @IBAction private func tapCloseHelpButton() {
        UIView.animate(withDuration: 0.2,
                       animations: { self.helpView.alpha = 0.0 },
                       completion: { _ in self.helpView.isHidden = true })
    }

    func getGameSnapshot() -> UIImage {
        let cgImage = skView!.texture(from: scene.gameLayer)!.cgImage()
        return UIImage(cgImage: cgImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        skView = SKView(frame: view.frame)
        skView.isMultipleTouchEnabled = false
        view.addSubview(skView)

        scene = GameScene(size: skView.bounds.size)
        scene.gameSceneDelegate = self
        scene.scaleMode = .aspectFill
        scene.board = board
        scene.mandatoryCaptureLabel = mandatoryCaptureLabel
        scene.renderBoard()

        skView.presentScene(scene)
        view.bringSubview(toFront: helpView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        skView.frame = boardView.frame
    }
}

extension GameViewController: GameSceneDelegate {
    func didFinishMove() {
        delegate?.didFinishMove(
            setupValue: board.setupValue,
            boardSizeValue: board.sizeValue,
            activePieceSetValue: board.activePieceSetValue,
            backwardJumpsValue: board.backwardJumpsValue,
            backwardJumpsInSequencesValue: board.backwardJumpsInSequencesValue,
            mandatoryCapturingValue: board.mandatoryCapturingValue,
            snapshot: getGameSnapshot())
    }
}
