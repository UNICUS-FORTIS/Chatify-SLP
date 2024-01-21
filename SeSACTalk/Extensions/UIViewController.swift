//
//  UIAlertController+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/20/24.
//

import UIKit


extension UIViewController {
    
    func showWorkspaceSheet() {
        
        let sheet = UIAlertController(title: "", message: "",
                                      preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "워크스페이스 편집", style: .default) { action in
            print("워크스페이스 편집")
        }
        
        let exit = UIAlertAction(title: "워크스페이스 나가기", style: .destructive) { action in
            print("나가기")
        }
        
        let changeOwner = UIAlertAction(title: "워크스페이스 관리자 변경", style: .destructive) { action in
            print("변경")
        }
        
        let delete = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { action in
            print("삭제")
        }
        
        sheet.addAction(edit)
        sheet.addAction(exit)
        sheet.addAction(changeOwner)
        sheet.addAction(delete)
        present(sheet, animated: true)
    }
}
