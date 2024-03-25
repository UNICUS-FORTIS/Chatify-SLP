# <p align="center">Chatify 🍇</p>
<p align="center">

<img width="30%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/685482e5-5cf2-4580-8e09-fc319e0f2a87"/>

#### <p align="center">Chatify 는 여러명의 유저가 다양한 공간에서 워크스페이스 그룹을 형성하고 소통하는 공간입니다.<br></br></p>

<p>
<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/9fb06f07-c586-4fcc-8df1-2e8249282808"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/27972b6b-6626-4616-9ec6-aa0ab8db540c"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/bd79078b-5062-4ba1-8a86-c3219734637a"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/0048c49e-d042-4e64-b9e9-5b053c1f8f1d"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/61386b35-b7f4-41a0-8996-591a0fb2cc23"/>

</p>

## 프로젝트 기간 🎀 
2024.01.03 ~ 2024.02.29

## 프로젝트 구분 🎀
iOS 1인 개발 (Design & Server part 협업)

## Deployment Target 🎀
iOS 15.0
 
## Main Features ✨
- 로컬 이메일 & 소셜 로그인 (Apple / Kakao)
- 자동 로그인
- Payment Gayway SDK 를 통한 결제 지원
- 채널 채팅 & DM 채팅
- 채팅 Push Notification
- 워크스페이스 생성 / 삭제
- 워크스페이스 내 채널 생성 / 삭제


## Sub Features 🌙
- 워크스페이스 관리자, 채널 관리자 위임
- 워크스페이스 멤버 초대
- 워크스페이스, 채널의 참여와 탈퇴

## Tech Stacks 🛠
- CodeBase UIKit, MVVM Architecture
- RxSwift, RxDatasource, RxKeyboard
- RxKakao Open SDK, Sigin In with Apple
- RealmSwift, SocketIO, Firebase Cloud Messaging
- Moya, SnapKit, Toast, SideMenu, FloatingPanel, Kingfisher
- Payment Gateway SDK
- CollectionView Compositional Layout, UserDefaults,
- Apple Push Notification service

## 주요 기술 🌖
- 로그인 방법에 따라 각자 다른 로그인 프로세스에 대응하기 위하여 뷰컨트롤러에서 분기처리를 통해 로컬 이메일 로그인과, 소셜 로그인 기능을 구현하였습니다.
- RealmSwift를 사용하여 로그인하는 어카운트 별 워크스페이스, 채널, DM 정보 데이터베이스 빌드 로직 구현<BR>
  -> 신규 워크스페이스 및 채널생성, 채널 채팅, DM 채팅 발생시 데이터 업데이트 로직을 간소화 하였습니다.<BR>
  -> 이 부분에서 Realm 의 Transaction 이 중복되지 않도록 하여 런타임 에러가 발생하지 않도록 고려하였습니다.
- SocketIO를 활용한 리얼타임 채팅구현, Realm Swift의 적절한 스케마 구현으로 읽지 않은 채팅까지만 DB에 저장하고 신규채팅이 로드되면 DB에 업데이트하는 로직을 구현하였습니다.
- RxDataSource 를 사용하여 섹션 별 다른 타입, 다른 셀을 적용하는것으로 채널 리스트와 DM채팅 리스트를 구현하였습니다.
- RxKeyboard 를 사용하여 간단히 키보드 Up / Down 을 반응형으로 대응하였습니다.
- Protocol과 Protocol의 Extension 사용으로 비슷한 기능을 가진 요소들을 추상화 하여 기능 구현시 편의성을 높였습니다.
- Moya 의 TargetType 을 사용한 라우터를 추상화 하고, RxMoya와 Generic Syntax 를 사용하여 네트워크 리퀘스트모델을 범용적으로 사용하도록 하였습니다.
- Interceptor를 사용하여 엑세스 토큰이 만료되었을 때 자동으로 토큰을 갱신하고 Retry 하도록 로직을 구성했습니다.
- Custom Delegate Pattern 과 Closure 전달 방식으로 화면 이동에 대한 동작을 사용하고 PresentingViewController 에 대하여 이해하여 두개의 뷰를 dismiss 이후 Completion Handler 에서 사후 동작을 정의하였습니다.
- 유저와 인터렉션시 각 케이스를 프로토콜로 추상화 하고 해당 뷰를 초기화 할 때 의존성을 주입하는 방식으로 하나의 뷰에서 두가지 인터렉션 타입을 받을 수 있도록 구현하였습니다.
- PaymentGateway SDK 를 사용하여 신용카드결제 등 다양한 결제 수단에 대응 하였습니다.


## 개발시 고려 사항 💎
**1. Apple Login / Kakao Login / Email Login**
<br>
<br>
<img width="70%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/1b46ab5c-4de5-4408-a92b-a8f41ca4c5fd"/>

**- 애플로그인**<br>
애플로그인은 설정에서 앱에 대한 애플로그인을 Revoke 시키지 않는 한 첫 로그인때만 유저에 대한 정보(풀네임, 이메일주소)를 얻을 수 있기 때문에 적절한 시점에 UserDefault 또는 KeyChain 에 저장해야 했습니다. UserDefault, Keychain 둘다 기기 디바이스에 저장하는데 있어서 100% 보안이 완벽한것은 아닐것입니다.
키체인 접근을 사용하면 저장된 키나 인증서 등을 볼 수 있게되고 UserDefault 또한 Jail Break 같은 행위를 통해 볼수 있게 됩니다. 그래서 저는 UserDefalut에 최소한의 정보만 저장하고 또 필요치 않을때는 삭제하는 방식을 택했습니다. 따라서 최초 로그인때 유저의 풀네임을 UserDefault 에 저장하였습니다.
 두번째 로그인부터는 애플로그인의 Credential.identityToken 은 제공되지만 이메일은 제공받을 수 없어 identityToken 을 파싱하여 이메일을 얻고 UserDefault 에 세이브 하였습니다.
 해당 정보들로 서버에서 요구하는 애플 IdentityToken 과 사용자 이름, 디바이스 토큰을 전송하는 로직을 구성했습니다.

**- 카카오로그인**<br>
카카오 로그인을 하고 SDK 에서 관리되는 oAuthToken 을 수신하여 디바이스토큰과 함께 서버에 로그인을 요청하였습니다.

**- 이메일 로그인**<br>
유저가 입력한 이메일 계정과 패스워드로 서버에 로그인을 요청합니다.
모든 로그인 방법에 대한 서버 응답으로 accessToken 과 refreshToken 이 오면 UserDefault 에 저장하고 만료시에 Interceptor 에 의해 갱신되면 UserDefault 에 저장되도록 하였습니다.

**- Auto Login**<br>
  굳이 KeyChain을 사용할 필요가 없었습니다. 로그인시 UserDefault 에 열거형으로 선언한 LoginMethod 를 저장하고 필요한 유저 정보를 디바이스에 저장합니다.
  앱이 종료되었다가 다시 실행 될 때 SceneDelegate 에서 저장된 LoginMethod 를 확인하여 nil (로그아웃한 상태) 가 아니라면 애플로그인의 경우 Credential State 를 판단하여 authorized 인 경우 LoginGateViewController를 RootViewContoller 로 지정합니다. 카카오와 이메일 로그인의 경우도 마찬가지로 로그인 게이트로 연결되며 카카오와 이메일 로그인의 경우 LoginGateViewController 가 RootViewController 로 지정되기 전 Social Login Handler 에서 로그인 리퀘스트를 수행하고 응답이 왔을 때 동작을 수행합니다.


**2. 디바이스에서 로그인시 데이터베이스 빌드 로직**
<br>
<br>
  <img width="70%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/e2009057-3c92-45bf-ab12-f81a7c12d296"/>

- 하나의 디바이스에서 로그아웃 이후 다른 아이디로 로그인 하는 경우에 대비하여 userID 를 PK 로 지정하고 각각의 userID 별 워크스페이스, 채널, DM 의 공간을 로그인 시점에 확보하도록 하였습니다.
- 현재의 채널에서 다른 채널로 옮겨가기 위해 사이드 메뉴의 채널을 선택 했을 때 해당 워크스페이스의 정보를 fetch 하고 그 워크스페이스의 채널 리스트와 DM 리스트를 갱신하면서 혹시라도 그 사이에 추가 되었을 채널 리스트와 DM 리스트의 데이터베이스 정보를 다시한번 확인하고 존재하지 않는 리스트를 기존의 데이터베이스에 Append 하도록 하였습니다.

**3. 워크스페이스를 나가거나 삭제 할 경우**<br>
- DM 리스트와 채팅리스트는 보전합니다.
- 워크스페이스의 상세 정보를 다시한번 서버에 요청하고 응답으로 온 채널 리스트와 데이터베이스를 비교하여 존재하는 데이터베이스에 존재하는 각각의 채널 리스트에 대한 채팅이력을 삭제합니다.
- 각각의 채널 리스트에 대한 채팅 이력을 삭제 후 각각의 채널 리스트를 삭제합니다.
- 각각의 채널 리스트를 삭제 한 후 워크스페이스 리스트를 삭제합니다.
- 위의 모든 동작을 수해애 후 해당 워크스페이스를 delete 후 트랜잭션을 종료합니다.

**4. 채널을 나가거나 삭제 할 경우**<br>
- DM 리스트와 채팅리스트는 보전합니다.
- 서버에 채널을 나가도록 요청을 보내고 성공응답 수신시 새로운 채널 목록을 업데이트 하여 앱에 반영합니다.
- 현재 채널 내 채팅 데이터를 모든 데이터를 삭제한 후, 채널 목록을 데이터베이스에서 삭제합니다.

**5. 신규 워크스페이스 / 채널 생성 또는 가입시**<br>
- 유저 DB 내의 모든 리스트는 채널 또는 DM 그리고 각각의 채팅이 존재하지 않는 한 빈 List 배열로 초기화 되어 있습니다. 따라서 단순히 append 후 서버에 현재 UserID 로 가입된 워크스페이스 목록 또는 채널목록을 다시 조회하고 업데이트 합니다.

**6.읽지 않은 채팅의 처리 (채널 또는 DM 오픈시 생성 시점에 대한 컬럼 추가)**
<br>
- 채널을 생성하거나 DM 채팅이 오픈되었을 경우 각각 데이터가 생성된 시점을 서버에서 받는 Cursor Date 으로 포맷 된 now() 로 초기화 하였습니다.
- 실제 디바이스에서 주고받은 채팅 이력이 단 한건도 존재하지 않을 경우 데이터가 생성된 시점을 Cursor Date로 설정해 서버에 그 시점 이후의 데이터를 요청합니다.
- 따라서 채널에 가입 이전의 채팅 이력에 대해 가져오는 일이 발생하지 않게 되고, DM 채팅이 오픈되었더라도 상대가 보낸 모든 채팅을 수신 할 수 있도록 하였습니다.
- 그렇게 읽지 않은 채팅을 서버로부터 응답으로 받으면 데이터베이스에 업데이트 하게되고 그 이후부터 가장 마지막 채팅의 CreatedAt 속성을 Cursor 로 사용하도록 로직을 생성했습니다.


## Trouble Shooting 🎀
### 1. Rx 의 Observable 과 채팅 TableView 의 Cell Data Binding
#### Trouble: 옵저버블의 데이터를 테이블뷰와 바인딩후, 옵저버블의 데이터가 갱신되었을 때 UI 와 실제 데이터가 불일치하는 현상

- 첫번째 문제는 앱의 사이드메뉴에서 워크스페이스 목록을 담당하는 테이블뷰에서 발생했습니다.
- 기존의 워크스페이스 목록을 받은 옵저버블을 테이블뷰에 바인딩후 신규 워크스페이스가 추가되어 onNext로 새 목록으로 갱신 하면 목록의 순서가 역전되었고 정렬 로직을 추가하더라도 문제는 동일했습니다.
- 기존 데이터 구독을 해지하기 위하여 Cell 내의 PrepareForReuse 의 처리가 되어 있음에도 불구하고 실제 셀의 데이터를 확인해보면 UI 에 표시된 워크스페이스 이름과 실제 데이터가 달랐습니다.

#### Solution: 셀에 데이터를 할당을 함수로 입력하는 방식으로 변경
- 옵저버블의 데이터가 변경되어 셀의 데이터가 갱신 될 때 셀 내의 옵저버블을 구독이 해제 되기 전에 셀의 재사용 매커니즘에 의하여 기존의 셀이 재사용 되고 그 이후에 새로운 데이터가 바인딩 되는것으로 추측했습니다.
- 이러한 문제를 해결 하고자 셀 내부의 옵저버블의 데이터를 외부에서 주입받아 바인딩 하는 방식에서 벗어나 워크스페이스, 또는 채널, 채팅의 셀의 데이터 할당 방식을 함수로 직접 셀의 변수에 데이터를 할당하는 방식으로 변경하여 해결했습니다.

  
### 2. 채팅 텍스트 길이에 따른 타임스탬프 넓이의 Hugging Priorty
  <img width="50%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/971de7f9-1f04-42a8-bf84-8c37d03bf7bc"/>  

#### Trouble: 타임 스탬프가 오늘이 아닐 때 이전 날짜를 포함하면서 더 많은 공간이 보장되어야했으나 화면 밖으로 벗어나거나 점으로 축약되는 현상 발생
- 오늘날짜의 경우 타임스탬프는 단순히 오전 또는 오후 + 시간만 표시하면 되나 이전 날짜의 경우 타임스탬프의 공간을 확장하는 동시에 가로 너비가 보장되지 않는 문제가 발생했습니다.

#### Solution: 
<img width="70%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/49bbbc44-bd4e-4bde-bcc1-cc84e1f56af9"/>

- 앱 내 UI 오토레이아웃 제약조건 설정시 SnapKit 을 사용했습니다.
- 타임스탬프 컨테이너의 너비의 Hugging Priorty 를 내부 컨텐츠 사이즈인 intrinsicContentSize.width 보다 크거나 같도록 하고 우선순위를 높였습니다.
- 동시에 컨텐츠를 담는 컨테이너, 즉 텍스트 채팅과 사진을 포함하여 이 컨테이너의 내부 컨텐츠 사이즈보다 작거나 같도록 하고 우선순위를 높였습니다.
- 타임 스탬프의 너비를 실제 너비만큼 늘리는 속성을 부여하고 채팅 컨텐츠의 양에 의해 contentsContainer 가 늘어나지만 타임스탬프 너비가 보장되고 있을 때 contentsContainer 는 작아지려하기때문에 타임스탬프의 넓이를 확보할 수 있었습니다.

## 아쉬웠던점
### 구조화
- 코드의 중복을 피하기 위하여 보다 프로토콜을 잘 활용하고 싶었습니다. 채널 리스트 또는 워크스페이스 리스트, 워크스페이스의 멤버 리스트를 표현하기 위하여 필요한 항목들을 프로토콜로 정의하고 동작을 최대한 일관되도록 만들면서 해당 프로토콜을 따르고 있는 클래스를 생성하고 뷰컨트롤러를 생성하면서 의존성을 주입하는 패턴을 사용해보았습니다.

- 하지만 LoginSession 이라는 하나의 클래스에서 현재 로그인 된 계정의 대부분의 활동들을 담당하고 있다보니 기능이 추가 될 수록 점점 비대해져감을 체감하는 동시에 위에서 말한 작은 부분들처럼 계정의 다양한 활동에 대해서도 좀더 의무를 분담시킬 수 있지 않았을까 하는 아쉬움이 많이 남았습니다.
  
### 지나치게 자유로웠던 커밋 컨벤션
- 이번 프로젝트는 솔로 프로젝트로 커밋과 푸시가 전부 저의 주도 아래에 있었기 때문에 프로젝트 초기부터 파일 단위 또는 피쳐 단위와 같은 어떠한 컨벤션을 정하고 작업하지 못했던 부분이 아쉽습니다.

## 회고 & Future Action
- 소셜 로그인 기능을 구현하면서 Sign in with Apple 과 Kakao SDK 에 대한 사용경험을 얻을 수 있게 되었습니다.
- Payment Gateway SDK 를 사용하여 실제 결제를 구현해본 경험으로부터 모바일 결제 구현에 대한 어려움을 떨쳐 낼 수 있었습니다. 
 - RxSwift 기반의 프로젝트속에서 각각의 옵저버블의 구독시점에 따른 행동을 좀더 알 수 있게 되면서 제가 그동안 잘못해왔던 부분들에 대해 자기 객관화를 할 수 있었습니다.
- 두개의 뷰를 dismiss 하는 동작이 요구 될 때 PresentingViewController 와 PresentedViewController 의 차이점을 알게 되었고 이런 화면 이동을 구현하는데 있어서 겪었던 지식적인 어려움을 많은 부분 극복 할 수 있었습니다.
- 실시간 채팅 기능을 구현 할 때 서버에 과도한 데이터를 요청하지 않기 위해 읽지 않은 채팅 기능을 구현하면서 Realm 의 트랙잭션이 중복되지 않도록 고민할 수 있는 좋은 기회가 되었고 또 SocketIO 라이브러리를 사용했는데 새로운 라이브러리를 사용해 볼 수 있어서 흥미로웠습니다.
- 단순히 기능 구현 뿐만 아니라 데이터가 앱 내에서 업데이트 되었을 때 그 업데이트 된 데이터를 어떤 순간에 유저에게 업데이트 시켜야 할 지, 또 유저가 이전 화면으로 돌아갔을 때 즉각적으로 업데이트 된 데이터를 확인 할 수 있는지 사용자 측면에서의 고민을 할 수 있었습니다.
- 피그마와 기획 문서에 대해서 의미가 잘 이해되지 않는 부분에 대해 협업 할 수 있는 기회를 얻었고 개발자 입장에서 이해하고 개발해야 할 현업 개발자의 마음가짐을 어느정도 간접 체험 할 수 있는 귀중한 계기가 되었습니다.
- 이후 또다른 프로젝트나 제 출시 앱에 대한 리팩토링 시 지금까지의 그 어떤 프로젝트보다 더 구조적으로 아름다운 아키텍처를 고민하고 설계할것입니다.
- RxSwift 를 사용할 때 In-Out 패턴을 사용하지 않았으나 다음 프로젝트에서는 In-Out 패턴으로 좀더 코드를 깔끔하게 작성할것입니다.
- 커밋을 다소 작은 단위로 실행했습니다. 그래서 갈수록 커밋 히스토리가 복잡해지고 팀 협업에서 어려움을 초래하지 않도록 피처 또는 업데이트 등 커밋을 더 묶어서 처리하여 전체적인 컨텍스트를 이해하는데 도움이 되도록 할것입니다.

## Scene & Interactions ⚡

<p>
<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/b361ed93-38d0-48d7-8e1a-d0a13f221dc6"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/26fe16c6-c3f1-4688-91aa-baf977ab38cc"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/497f4351-961e-45ac-833c-e99cee8fc06a"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/b1eb2d3a-64a0-4588-9c54-2e4fbef1baae"/>

</p>

#### 1. 회원가입 (유효성검사)
- 이메일 형식, 이메일 중복검사(API), 닉네임 글자 수 제한, 비밀번호 (영문 대소문자+숫자+특수문자 조합), 비밀번호 확인 일치여부
- 유효성을 통과하지 못했을 때 레이블 위 PlaceHolder 를 Error Color 로 변경.
- 여러 항목이 유효성을 통과하지 못했을 때 가장 위에있는 항목의 TextField 를 FirstResponder 로 설정
- 토스트 메시지 출력

  
#### 2. 이메일 로그인
- 이메일 형식, 비밀번호 유효성 통과시에만 로그인 요청 네트워킹 실행
- 유효성을 통과하지 못했을 때 레이블 위 PlaceHolder 를 Error Color 로 변경.
- 여러 항목이 유효성을 통과하지 못했을 때 가장 위에있는 항목의 TextField 를 FirstResponder 로 설정
- 토스트 메시지 출력


#### 3. 로그인 직후
<p>
<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/d8915fc8-dd69-4f95-9b78-2e1f059bf7c1"/>
 
<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/7e2e3f0e-134e-45be-a6e8-db29d674e216"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/f7840856-1208-4f09-a050-5169ac36d157"/>
</p>

- 워크스페이스 보유시 DefaultViewController 로 전환
- 워크스페이스 미보유시 HomeEmptyViewController 로 전환


#### 4. HomeEmptyViewController 로 전환시
- 사이드메뉴의 컨텐츠가 빈 워크스페이스 목록이 아니라 워크스페이스가 없다는 리터럴 노출 및 생성 버튼을 노출
- 네비게이션 영역의 워크스페이스 타이틀을 No Workspace 로 설정.


#### 5. DefaultViewController 로 전환시
- 사이드메뉴의 컨텐츠가 워크스페이스 목록으로 노출
- 네비게이션 영역의 Left View 가 선택된 워크스페이스 이름으로 노출

#### 6. 워크스페이스 컨트롤 옵션 (편집, 나가기, 관리자변경, 삭제)

<p>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/aee9c9ef-70a0-4e74-8263-c45a14c89b36"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/1a2da9c9-903b-46a7-b253-aecb41db382a"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/3992bd36-8241-44b1-8d1f-68534ae0154a"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/f462136c-84eb-485e-8c90-ba6303d949e6"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/52edeca7-8dda-44a8-bf97-a1f296184e71"/>

</p>


#### 7. 워크스페이스 멤버 초대

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/681f35bb-a202-4a3a-976d-56015ddb64e9"/>

- 서버에 초대 요청 Fetch 후 200 OK 응답 시 토스트 메세지 출력


#### 8. 채널 (편집, 관리자 변경, 삭제, 나가기)
<p>
<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/8010afb4-a304-470c-a330-4c01c19761c1"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/9aee79fc-185e-4fae-ae49-3cc3c16f2446"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/14628539-6fb7-4f30-a453-f659d89bc80c"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/49f8a64f-a783-4487-b5cc-519ca7b61f9b"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/9b52065b-cbe2-4c99-a6b5-e00809cc9edb"/>

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/1967b270-34d4-4cdc-919a-d31908e144b7"/>

</p>

- 채널 관리자가 아닌 멤버의 경우 오직 '나가기' 버튼만 노출되고 나머지 버튼은 Hidden 과 isEnabled = false 를 주었습니다.
- 채널에 멤버가 본인만 존재 할 경우 관리자를 변경 할 수 없는 백드롭 뷰의 인터렉션이 등장합니다.
- 채널의 관리자가 나가기를 선택 할 경우 관리자 권한을 양도하고 나갈 수 있다는 인터렉션이 등장합니다.


#### 9. PG 결제 화면

<img width="19%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/1c45b508-ff21-4fe0-89c6-e8ede969a7a0"/>

- 결제가 완료되고 uid 응답 두가지로 서버에 영수증 검증을 Fetch 후 200 OK 응답이 왔을 때 코인이 충전이 완료되었다는 토스트 메세지를 출력합니다.


#### 10. Sign In with Apple & Kakao Login + Log out

<img width="25%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/7158c98e-1b14-4f2d-89ba-01d2b6bcc54d"/>

- 실기기의 애플 로그인 이후 로그아웃, 그리고 연이어 카카오 로그인 실행 화면입니다.
- 앱 이름 변경 전에 실기기에 빌드되어 녹화된 화면입니다.

#### 11. 프로필 사진 변경 및 네비게이션 영역에 즉시 반영

<img width="25%" src="https://github.com/UNICUS-FORTIS/Chatify-SLP/assets/110699030/913b39ee-535a-4b4c-90da-7387f56e2fe5"/>

- 프로필 사진 변경 완료 이후 GIF 가 바로 루핑되지만 정상적으로 프로필 사진이 바뀌는것을 확인 할 수 있습니다.

