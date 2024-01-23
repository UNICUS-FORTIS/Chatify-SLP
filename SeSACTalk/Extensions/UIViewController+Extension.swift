//
//  UIAlertController+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/20/24.
//

import UIKit


extension UIViewController {
    
    func showWorkspaceSheet(workspace: WorkSpace) {
                
        let sheet = UIAlertController(title: "", message: "",
                                      preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "워크스페이스 편집", style: .default) { [weak self] action in
            
            let vc = WorkSpaceEditViewController(viewModel: EmptyWorkSpaceViewModel(editMode: .edit,
                                                                                    workspaceInfo: workspace))
            let navVC = UINavigationController(rootViewController: vc)
            vc.modalTransitionStyle = .coverVertical
            self?.present(navVC, animated: true)
        }
        
        let exit = UIAlertAction(title: "워크스페이스 나가기", style: .default) { action in
            print("나가기")
        }
        
        let changeOwner = UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { action in
            print("변경")
        }
        
        let delete = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { action in
            print("삭제")
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소")
        }
        
        sheet.addAction(edit)
        sheet.addAction(exit)
        sheet.addAction(changeOwner)
        sheet.addAction(delete)
        sheet.addAction(cancel)
        present(sheet, animated: true)
    }
}
