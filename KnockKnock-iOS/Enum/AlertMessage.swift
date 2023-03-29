//
//  AlertMessage.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/07.
//

import Foundation

enum AlertMessage: String {
  case registerDone = "회원가입에 성공하였습니다."
  case registerFailed = "회원가입에 실패하였습니다."

  case signOutConfirm = "로그아웃 하시겠습니까?"
  case signOutDone = "성공적으로 로그아웃 처리 되었습니다."

  case withdrawConfirm = "계정을 삭제하면 게시글, 좋아요, 댓글 등 모든 활동 정보가 삭제됩니다. 그래도 탈퇴 하시겠습니까?"
  case withdrawDone = "성공적으로 탈퇴 처리 되었습니다."

  case versionNewest = "현재 최신버전을 사용중입니다."
  case versionOld = "업데이트가 필요합니다."
  case versionUnknown = "버전 정보를 불러올 수 없습니다."
  
  case profileSetting = "프로필 등록을 완료하였습니다."

  case addressSearchFailed = "검색에 실패하였습니다. 잠시 후에 다시 시도해 주세요."

  case feedWriteConfirm = "게시글 등록을 완료 하시겠습니까?"
  case feedWriteNeedFill = "사진, 태그, 프로모션, 내용은 필수 입력 항목입니다."

  case feedEditConfirm = "게시글을 수정하시겠습니까?"
  case feedEditDone = "게시글 수정이 완료되었습니다."
  case feedEditFailed = "게시글 수정에 실패하였습니다."

  case feedDeleteConfirm = "게시글을 삭제하시겠습니까?"
  case feedDeleteDone = "게시글이 삭제되었습니다."
  case feedDeleteFailed = "게시글 삭제 중 오류가 발생하였습니다."

  case feedHideConfirm = "이 게시글을 숨김 처리 하시겠습니까?"
  case feedHideDone = "게시글이 숨김 처리 되었습니다."
  case feedHideFailed = "게시글 숨김 처리에 실패하였습니다."

  case feedReportDone = "게시글이 신고 되었습니다."
  case feedReportFailed = "게시글 신고에 실패하였습니다."

  case commentDeleteConfirm = "댓글을 삭제하시겠습니까?"
  case commentDeleteFailed = "댓글 삭제에 실패하였습니다."
  case commentFailed = "댓글 등록에 실패하였습니다."

  case isDuplicatedNickname = "이미 사용되고 있는 닉네임입니다."

  case pageLoadFailed = "페이지 로드 실패"

  case unknownedError = "처리 중 오류가 발생하였습니다. 관리자에게 문의하세요."

  case unaccessible = "잘못 된 접근입니다."
}
