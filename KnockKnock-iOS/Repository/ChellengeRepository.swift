//
//  ChellengeRepository.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/23.
//

import Foundation

import Alamofire

protocol ChallengeRepositoryProtocol {
  func fetchChellenge(completionHandler: @escaping ([Challenges]) -> Void)
  func getChallengeDetail(completionHandler: @escaping (ChallengeDetail) -> Void)
}

final class ChallengeRepository: ChallengeRepositoryProtocol {
  func fetchChellenge(completionHandler: @escaping ([Challenges]) -> Void) {
    KKNetworkManager.shared
      .request(
        object: [Challenges].self,
        router: KKRouter.requestChallengeResponse,
        success: { response in
          completionHandler(response)
        },
        failure: { response in
          print(response)
        })
  }

  func getChallengeDetail(completionHandler: @escaping (ChallengeDetail) -> Void) {
    let detail =
      ChallengeDetail(
        image: "",
        title: "#고고챌린지",
        summary: "고고 릴레이 챌린지’는 생활 속 플라스틱을 줄이기 위해 ‘(하지 말아야 할 한 가지를 거부하)고, (해야 할 한 가지 실천을 하)고’에서 따온 말로, 환경부가 2021년 1월 4일부터 시작한 캠페인이다. 이는 생활 속 플라스틱을 줄이기 위해 일상에서 하지 말아야 할 1가지 행동과 할 수 있는 1가지 행동을 약속하는 것으로, 플라스틱 사용을 줄이고 거부하는 실천 약속(사진과 영상 등)을 본인의 SNS 등에 올리고 다음 도전자를 지명하는 방식으로 이뤄진다.",
        practice: [
          "환경에 도움되는 실천 한가지 하기",
          "본인의 SNS에 #고고챌린지 태그와 함께 업로드 하기",
          "다음 도전자를 지명하기"
        ],
        contents: [
          ChallengeContent(
            title: "기업이 함께하는 ‘고고 챌린지’",
            image: "",
            content: "고고챌린지는 기업의 SNS를 통해 ESG 경영 곁가지로 번지며 적극적인 참여가 이루어지고 있다. 대부분의 환경 챌린지가 개인 중심으로 일어나는 것에 비해, 기업의 적극적인 참여가 이루어지고 있다는 것이 고고챌린지의 큰 특징이다. 대다수의 기업이 사내 텀블러 및 머그컵 배포를 통한 일회용품 줄이기를 통해 고고 챌린지에 참여하고 있다. 그 외에 제주항공은 기내 생분해 플라스틱 봉투 활용을 제시했으며, 뱅크샐러드는 점심 식사로 제공되는 도시락에 친환경 펄프 용기를 사용하여 플라스틱 사용을 줄이고 있다. 또한 bc카드의 경우 불필요한 종이 영수증을 줄이고, 사막화를 막는 나무 심기 활동을 이어가고 있다."
          ),
          ChallengeContent(
            title: "개인도 참여가능한 ‘고고 챌린지’",
            image: "",
            content: "개인이 고고챌린지에 참여하려면 어떻게 해야 할까. 고고챌린지 실천운동의 첫 주자였던 조명래 환경부 장관의 경우 일회용 빨대 사용하지 않기, 텀블러 사용하기를 약속하고 이를 환경부 SNS에 공유하며 다음 주자를 지명하였다. 이런 방식으로 하지 말아야 할 1가지 행동과 할 수 있는 1가지 행동을 정하고 가능하다면 다음 주자를 지정하여 SNS에 공유하면 참여가 가능하다. 환경 실천 행동의 경우 비닐봉지 대신 장바구니 사용하기, 음료 구매 시 무라벨 제품 우선 구매하기, 온라인 상품 주문은 모아서 한꺼번에 하기, 배달 주문 시 사용하지 않는 플라스틱 거절하기 등이 있다."
                          ),
          ChallengeContent(
            title: "다양한 업사이클링 브랜드",
            image: "",
            content: "커피 마대 자루, 자투리 가죽, 헌 옷, 잠수복, 웨딩드레스, 양말목 등 새활용으로 재탄생한 소재는 무궁무진하다. 최근엔 플라스틱 문제가 심각해지면서 많은 브랜드가 페트병을 활용해 옷, 가방, 운동화 등의 제품을 선보이고 있다.\n \n 업사이클링 브랜드들은 각자 재활용하는 소재들이 정해져 있고 그 자체를 콘셉트로 디자인에 반영하여 제품을 생산, 판매하고 있다. 보통 내구성이 좋은 소재들을 활용해 가방, 지갑 등의 잡화를 만드는 패션 브랜드들이 많다. 자동차 방수천과 안전벨트로 가방을 만드는 프라이탁(FREITAG)에서부터 거리의 현수막과 타이어 튜브를 활용하는 누깍(Nukak), 폐우산과 현수막을 재활용하는 큐클리프(Cueclyp), 군용 텐트를 재활용하는 카네이테이(Kaneitai) 등이 있다. \n \n 가장 대표적인 국내 브랜드인 플리츠마마(PLEATSMAMA)는 폐페트병 16개를 활용한 원사로 1개의 니트 에코백을 만든다. 지난해 제주 프로젝트를 통해 500mL 생수병 170만 개가 가방과 소품으로 재탄생했다. 페트병 뚜껑을 기부받아 코스터, 키링, 선반 등 작은 소품을 만드는 작업도 늘어나고 있다. 서울환경연합에서 운영하는 플라스틱 방앗간은 신청을 통해 따로 참여자(참새 클럽)를 모으고 병뚜껑을 기부하면 리워드 형태로 업사이클링 제품을 제공하고 있다. \n \n 그 외에 푸드 업사이클링도 주목할 만하다. 리하베스트(RE:harvest)는 맥주 및 식혜의 부산물을 활용해 영양바인 '리너지바(RE:nergy bar)'를 만들었다. 라이프스타일 브랜드 '소나이트(SONITE)'는 농업 과정에서 버려지는 벼 껍질을 활용해 트레이, 코스터 등의 제품을 선보이고 있다. 음식물 쓰레기가 전 세계 온실가스 배출량의 약 10%를 차지하는 만큼 기대되는 분야 중 하나다.\n \n 코로나19 이후로 일상이 된 일회용 마스크가 심각한 쓰레기 문제를 발생시키고 있는데 이를 해결하고자 나선 디자이너도 있다. 김하늘 디자이너는 마스크의 재질이 플라스틱의 일종인 폴리프로필렌(pp)이라는 점에 착안하여 약 1천5백 장의 폐마스크로 의자를 만들었다.\n \n 아주 잠깐 사용되고 쓰임이 다하거나 유행이 지나 버려지는 물건 중 재활용이 어려운 소재일 때, 업사이클링을 통해 다시 인간의 공간 어딘가에 머물게 된다면 환경적인 측면에서 긍정적이고 지구상에 더 이상 둘 곳 없는 쓰레기들의 안식처가 될 수 있다.")
        ],
        participants: [
          Participant(id: 2, nickname: "", image: nil),
          Participant(id: 2, nickname: "", image: nil),
          Participant(id: 2, nickname: "", image: nil)
        ])
    completionHandler(detail)
  }
}
