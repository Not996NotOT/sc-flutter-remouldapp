import 'package:flutter/material.dart';
import 'package:notarization_station_app/page/helper/widget/duigong_detail.dart';
import 'package:notarization_station_app/page/helper/widget/hetong_detail.dart';
import 'package:notarization_station_app/page/helper/widget/shipin_detail.dart';
import 'package:notarization_station_app/page/helper/widget/zaixian_detail.dart';
import 'package:notarization_station_app/page/helper/widget/zizhu_detail.dart';
import 'package:notarization_station_app/page/home/addAppointment.dart';
import 'package:notarization_station_app/page/home/applyInfo.dart';
import 'package:notarization_station_app/page/home/appointment.dart';
import 'package:notarization_station_app/page/home/bank/bank_ing.dart';
import 'package:notarization_station_app/page/home/bank/bank_list.dart';
import 'package:notarization_station_app/page/home/bank/ious_list.dart';
import 'package:notarization_station_app/page/home/case_detail.dart';
import 'package:notarization_station_app/page/home/case_handle_show_pdf.dart';
import 'package:notarization_station_app/page/home/case_handling_widget.dart';
import 'package:notarization_station_app/page/home/cashier_desk.dart';
import 'package:notarization_station_app/page/home/conference/conference_ing.dart';
import 'package:notarization_station_app/page/home/conference/video_conference.dart';
import 'package:notarization_station_app/page/home/confirmApplyInfo.dart';
import 'package:notarization_station_app/page/home/contractPeople.dart';
import 'package:notarization_station_app/page/home/contract_ing.dart';
import 'package:notarization_station_app/page/home/demo/demo.dart';
import 'package:notarization_station_app/page/home/electronic_notarial_certificate.dart';
import 'package:notarization_station_app/page/home/explain_page.dart';
import 'package:notarization_station_app/page/home/face.dart';
import 'package:notarization_station_app/page/home/face_fail.dart';
import 'package:notarization_station_app/page/home/financial_notarization_widget.dart';
import 'package:notarization_station_app/page/home/flutter_inappwebview_page.dart';
import 'package:notarization_station_app/page/home/judicial_expertise_list_widget.dart';
import 'package:notarization_station_app/page/home/judicial_expertise_login.dart';
import 'package:notarization_station_app/page/home/live_broadcast_room_selection.dart';
import 'package:notarization_station_app/page/home/live_room_and_introduce.dart';
import 'package:notarization_station_app/page/home/notary_extract_widget.dart';
import 'package:notarization_station_app/page/home/notary_office_list_widget.dart';
import 'package:notarization_station_app/page/home/protocol/protocol.dart';
import 'package:notarization_station_app/page/home/protocol/protocol_ing.dart';
import 'package:notarization_station_app/page/home/reception_room.dart';
import 'package:notarization_station_app/page/home/scan_widget.dart';
import 'package:notarization_station_app/page/home/selectPublicContent.dart';
import 'package:notarization_station_app/page/home/select_room_history.dart';
import 'package:notarization_station_app/page/home/signature_widget.dart';
import 'package:notarization_station_app/page/home/small/small_money.dart';
import 'package:notarization_station_app/page/home/small/small_new.dart';
import 'package:notarization_station_app/page/home/small/small_video_auth.dart';
import 'package:notarization_station_app/page/home/submitOrderList.dart';
import 'package:notarization_station_app/page/home/uploadMaterial.dart';
import 'package:notarization_station_app/page/home/videoUnfinishedPage.dart';
import 'package:notarization_station_app/page/home/video_ing.dart';
import 'package:notarization_station_app/page/home/video_notarize.dart';
import 'package:notarization_station_app/page/home/video_user_information.dart';
import 'package:notarization_station_app/page/home/vm/dialog/demo.dart';
import 'package:notarization_station_app/page/home/webViewPage.dart';
import 'package:notarization_station_app/page/home/widget/conference_ing.dart';
import 'package:notarization_station_app/page/home/widget/dianzi_name.dart';
import 'package:notarization_station_app/page/home/widget/rule_detail.dart';
import 'package:notarization_station_app/page/index.dart';
import 'package:notarization_station_app/page/infomation/add_friend.dart';
import 'package:notarization_station_app/page/infomation/chat.dart';
import 'package:notarization_station_app/page/infomation/guide.dart';
import 'package:notarization_station_app/page/infomation/matter_List.dart';
import 'package:notarization_station_app/page/infomation/message.dart';
import 'package:notarization_station_app/page/infomation/msg_inform.dart';
import 'package:notarization_station_app/page/infomation/news.dart';
import 'package:notarization_station_app/page/infomation/notary_Office.dart';
import 'package:notarization_station_app/page/infomation/notary_detail.dart';
import 'package:notarization_station_app/page/infomation/question_detail.dart';
import 'package:notarization_station_app/page/infomation/quiz.dart';
import 'package:notarization_station_app/page/infomation/search.dart';
import 'package:notarization_station_app/page/infomation/widget/guideDetail.dart';
import 'package:notarization_station_app/page/infomation/widget/infoDetail.dart';
import 'package:notarization_station_app/page/login/bind_email_address.dart';
import 'package:notarization_station_app/page/login/code_login.dart';
import 'package:notarization_station_app/page/login/login_page.dart';
import 'package:notarization_station_app/page/login/modify_password_page.dart';
import 'package:notarization_station_app/page/login/register.dart';
import 'package:notarization_station_app/page/login/register_explain.dart';
import 'package:notarization_station_app/page/mine/add_address_page.dart';
import 'package:notarization_station_app/page/mine/attestation_page.dart';
import 'package:notarization_station_app/page/mine/edit_head_portrait_page.dart';
import 'package:notarization_station_app/page/mine/face_compare.dart';
import 'package:notarization_station_app/page/mine/mine_address_list.dart';
import 'package:notarization_station_app/page/mine/mine_info_page.dart';
import 'package:notarization_station_app/page/mine/my_signature_apply_page.dart';
import 'package:notarization_station_app/page/mine/my_signature_setting.dart';
import 'package:notarization_station_app/page/mine/privacy_page.dart';
import 'package:notarization_station_app/page/mine/settings_page.dart';
import 'package:notarization_station_app/page/mine/user_agreement_page.dart';
import 'package:notarization_station_app/page/mine/widget/real_name_page.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../page/home/face_compare_identify.dart';
import '../utils/common_tools.dart';

class RoutePaths {
  static const String LOGIN = 'login';
  static const String HomeIndex = 'mainIndex';
  //用户协议，隐私政策
  static const String Privacy = 'privacy';
  static const String UserAgreement = 'userAgreement';
  static const String settings = 'settings';
  static const String MineAddressList = 'addressList';
  static const String AddAddress = 'addAddress';
  static const String MineInfo = 'mineInfo';
  static const String EditPortrait = 'editPortrait';
  static const String Attestation = 'attestation';
  static const String ModifyPsd = 'modifyPsd';
  static const String CodeLogin = 'codeLogin';
  static const String ShiPinDetail = 'shiPinDetail';
  static const String ZaiXianDetail = 'zaiXianDetail';
  static const String Explain = 'explain';
  static const String VideoNotarize = 'videoNotarize';
  static const String VideoIng = 'videoIng';
  static const String HeTongDetail = 'heTongDetail';
  static const String Register = 'register';
  static const String RealName = 'realName';
  static const String RuleDetail = 'ruleDetail';
  static const String DianziName = 'dianziName';
  static const String InfoDetail = 'infoDetail';
  static const String Face = 'face';
  static const String SelectPublicContent = 'selectPublicContent';
  static const String ApplyInfo = 'applyInfo';
  static const String ConfirmApplyInfo = 'confirmApplyInfo';
  static const String UploadMaterial = 'uploadMaterial';
  static const String SubmitOrderList = 'submitOrderList';
  static const String ContractPeople = 'contractPeople';
  static const String AskAndQuestion = 'askAndQuestion';
  static const String ContractIntroduce = 'contractIntroduce';
  static const String ContractIng = 'contractIng';
  static const String Upload = 'upload';
  static const String Test = 'test';
  static const String Video = 'video';
  static const String MemberList = 'memberList';
  static const String ZiZhuDetail = 'ziZhuDetail';
  static const String VideoConference = 'videoConference';
  static const String ConferenceDetails = 'conferenceDetails';
  static const String ConferenceIng = 'conferenceIng';
  static const String QuestionDetail = 'questionDetail';
  static const String Guide = 'guide';
  static const String MatterList = 'matterList';
  static const String Quiz = 'quiz';
  static const String NotaryOffice = 'notaryOffice';
  static const String NotaryDetail = 'notaryDetail';
  static const String Message = 'message';
  static const String Search = 'search';
  static const String News = 'news';
  static const String MsgInform = 'msgInform';
  static const String AddFriend = 'addFriend';
  static const String Chat = 'chat';
  static const String Sound = 'sound';
  static const String duiGongDetail = 'duiGongDetail';
  static const String Appointment = 'Appointment';
  static const String AddAppointment = 'addAppointment';
  static const String Protocol = 'Protocol';
  static const String ProtocolIng = 'ProtocolIng';
  static const String DomeIngPage = 'DomeIngPage';
  static const String GuideDetailPage = 'GuideDetailPage';
  static const String SmallMoneyPage = 'SmallMoneyPage';
  static const String SmallNew = 'smallNew';
  static const String SmallVideo = 'smallVideo';
  static const String FaceFail = 'faceFail';
  // 金融赋强
  static const String BankList = 'BankList';
  static const String Demo = 'Demo';
  static const String IndexDemo = 'IndexDemo';
  static const String BankIng = 'BankIng';
  static const String IousList = 'IousList';
  static const String financialNotarization = 'financialNotarization';
  static const String liveBroadcastRoom = 'liveBroadcastRoom';
  static const String receptionRoom = 'receptionRoom';
  static const String selectRoomHistory = 'selectRoomHistory';
  static const String liveRoomAndIntroduce = 'liveRoomAndIntroduce';
  static const String registerExplain = 'registerExplain';
  static const String faceCompare = 'faceCompare';
  static const String videoUserInformation = 'videoUserInformation';
  static const String scanWidget = "scanWidget";
  static const String webViewWidget = "webViewWidget";
  static const String bindEmailAddress = 'bindEmailAddress';
  static const String judicialExpertise = 'judicialExpertise';
  static const String caseHandle = "caseHandle";
  static const String judicialExpertiseList = "judicialExpertiseList";
  static const String caseDetailWidget = "caseDetailWidget";
  static const String notaryOfficeListWidget = "notaryOfficeListWidget";
  static const String caseHandleShowPDF = "caseHandleShowPDF";
  static const String signatureWidget = "signatureWidget";
  static const String notaryExtractWidget = "notaryExtractWidget";
  static const String faceCompareIdentifyWidget = "faceCompareIdentifyWidget";
  static const String cashierDesk = "cashierDesk";
  static const String ElectronicNotarialCertificate =
      "ElectronicNotarialCertificate";
  static const String LoginTypeFile = "LoginTypeFile";
  static const String videoUnfinished = "VideoUnfinished";
  static const String mySignatureSetting = "mySignatureSetting";
  static const String mySignatureApply = "mySignatureApply";
  static const String flutterInappwebview = "flutterInappwebview";
}

class Router {
  //路由列表
  static final _routes = {
    'login': (BuildContext context, {Object args}) =>
        LoginPage(arguments: args),
    'mainIndex': (BuildContext context, {Object args}) => MainIndexPage(),
    'privacy': (BuildContext context, {Object args}) => PrivacyPage(),
    'userAgreement': (BuildContext context, {Object args}) =>
        UserAgreementPage(),
    'settings': (BuildContext context, {Object args}) => SettingsPage(),
    'addressList': (BuildContext context, {Object args}) =>
        MineAddressListPage(),
    'addAddress': (BuildContext context, {Object args}) =>
        AddAddressPage(addressInfo: args),
    'mineInfo': (BuildContext context, {Object args}) => MineInfoPage(),
    'editPortrait': (BuildContext context, {Object args}) => EditPortraitPage(),
    'attestation': (BuildContext context, {Object args}) =>
        AttestationPage(arguments: args),
    'modifyPsd': (context, {Object args}) => ModifyPasswordPage(
          title: (args as Map)['title'],
          phoneNumber: (args as Map)['phoneNumber'],
        ),
    'codeLogin': (BuildContext context, {Object args}) => CodeLoginPage(),
    'shiPinDetail': (BuildContext context, {Object args}) =>
        ShiPinDetailPage(arguments: args),
    'zaiXianDetail': (BuildContext context, {Object args}) =>
        ZaiXianDetailPage(arguments: args),
    'explain': (BuildContext context, {Object args}) =>
        ExplainPage(arguments: args),
    'videoNotarize': (BuildContext context, {Object args}) =>
        VideoNotarizePage(),
    'videoIng': (BuildContext context, {Object args}) =>
        VideoIngPage(arguments: args),
    'heTongDetail': (BuildContext context, {Object args}) =>
        HeTongDetailPage(arguments: args),
    'register': (BuildContext context, {Object args}) => RegisterPage(
      unionId: (args as Map)['unionId'],
          appleId: (args as Map)['appleId'],
          mobile: (args as Map)['mobile'],
          loginType: (args as Map)['loginType'],
        ),
    'realName': (BuildContext context, {Object args}) => RealNamePage(
          comeFrom: (args as Map)['comeFrom'],
        ),
    'ruleDetail': (BuildContext context, {Object args}) => RuleDetailPage(),
    'dianziName': (BuildContext context, {Object args}) => DianziNamePage(),
    'infoDetail': (BuildContext context, {Object args}) =>
        InfoDetailPage(arguments: args),
    'face': (BuildContext context, {Object args}) => FacePage(arguments: args),
    'selectPublicContent': (BuildContext context, {Object args}) =>
        SelectPublicContentPage(arguments: args),
    'applyInfo': (BuildContext context, {Object args}) =>
        ApplyInfoPage(arguments: args),
    'confirmApplyInfo': (BuildContext context, {Object args}) =>
        ConfirmApplyInfoPage(arguments: args),
    'uploadMaterial': (BuildContext context, {Object args}) =>
        UploadMaterialPage(arguments: args),
    'submitOrderList': (BuildContext context, {Object args}) =>
        SubmitOrderListPage(arguments: args),
    'contractPeople': (BuildContext context, {Object args}) =>
        ContractPeoplePage(),
    'contractIng': (BuildContext context, {Object args}) =>
        ContractIngPage(arguments: args),
    // 'upload': (BuildContext context, {Object args}) => UploadPage(),
    'ziZhuDetail': (BuildContext context, {Object args}) =>
        ZiZhuDetailPage(arguments: args),
    'questionDetail': (BuildContext context, {Object args}) =>
        QuestionDetailPage(arguments: args),
    'guide': (BuildContext context, {Object args}) => GuidePage(),
    'matterList': (BuildContext context, {Object args}) =>
        MatterListPage(arguments: args),
    'quiz': (BuildContext context, {Object args}) => QuizPage(),
    'notaryOffice': (BuildContext context, {Object args}) => NotaryOfficePage(),
    'notaryDetail': (BuildContext context, {Object args}) =>
        NotaryDetailPage(arguments: args),
    'message': (BuildContext context, {Object args}) => MessagePage(),
    'search': (BuildContext context, {Object args}) => SearchBarPage(),
    'news': (BuildContext context, {Object args}) => NewsPage(arguments: args),
    'msgInform': (BuildContext context, {Object args}) =>
        MsgInformPage(arguments: args),
    'addFriend': (BuildContext context, {Object args}) => AddFriendPage(),
    'chat': (BuildContext context, {Object args}) => ChatPage(arguments: args),
    // 'sound': (BuildContext context, {Object args}) => RecordPage(),
    'duiGongDetail': (BuildContext context, {Object args}) =>
        DuiGongDetailPage(arguments: args),
    'Appointment': (BuildContext context, {Object args}) => AppointmentPage(),
    'addAppointment': (BuildContext context, {Object args}) =>
        AddAppointmentPage(),
    'videoConference': (BuildContext context, {Object args}) =>
        VideoConferencePage(),
    "conferenceIng": (BuildContext context, {Object args}) =>
        ConferenceIngPage(),
    'scanWidget': (BuildContext context, {Object args}) => ScanWidget(),
    'Protocol': (BuildContext context, {Object args}) => ProtocolPage(),
    'ProtocolIng': (BuildContext context, {Object args}) =>
        ProtocolIngPage(arguments: args),
    'DomeIngPage': (BuildContext context, {Object args}) => DomeIngPage(),
    'GuideDetailPage': (BuildContext context, {Object args}) =>
        GuideDetailPage(arguments: args),
    'SmallMoneyPage': (BuildContext context, {Object args}) => SmallMoneyPage(),
    'smallNew': (BuildContext context, {Object args}) =>
        SmallNewPage(route: args),
    'smallVideo': (BuildContext context, {Object args}) =>
        SmallVideoAuthPage(arguments: args),
    'faceFail': (BuildContext context, {Object args}) => FaceFailPage(),
    'BankList': (BuildContext context, {Object args}) => BankListPage(),
    'Demo': (BuildContext context, {Object args}) => DemoPage(),
    'IndexDemo': (BuildContext context, {Object args}) => IndexDemoPage(),
    'BankIng': (BuildContext context, {Object args}) =>
        BankIngPage(arguments: args),
    'IousList': (BuildContext context, {Object args}) => IousListPage(),
    'financialNotarization': (BuildContext context, {Object args}) =>
        FinancialNotarizationWidget(),
    'liveBroadcastRoom': (BuildContext context, {Object args}) =>
        LiveBroadcastRoomSelectionWidget(),
    'receptionRoom': (BuildContext context, {Object args}) =>
        ReceptionRoomWidget(
          data: args,
        ),
    'selectRoomHistory': (BuildContext context, {Object args}) =>
        SelectRoomHistoryWidget(),
    'liveRoomAndIntroduce': (BuildContext context, {Object args}) =>
        LiveRoomAndIntroduceWidget(),
    'registerExplain': (BuildContext context, {Object args}) =>
        RegisterExplainWidget(),
    'videoUserInformation': (BuildContext context, {Object args}) =>
        VideoUserInformation(),
    "bindEmailAddress": (BuildContext context, {Object args}) =>
        BindEmailAddress(
          phoneNumber: (args as Map)['phoneNumber'],
        ),
    "judicialExpertise": (BuildContext context, {Object args}) =>
        JudicialExpertiseLoginPage(),
    "caseHandle": (BuildContext context, {Object args}) => CaseHandingWidget(),
    'judicialExpertiseList': (BuildContext context, {Object args}) =>
        JudicialExpertiseListWidget(),
    "caseDetailWidget": (BuildContext context, {Object args}) =>
        CaseDetail(records: (args as Map)['model']),
    "notaryOfficeListWidget": (BuildContext context, {Object args}) =>
        NotaryOfficeListWidget(
          selectNotary: (args as Map)['selectNotary'],
          dataList: (args as Map)['notary'],
          unitGuid: (args as Map)['unitGuid'],
          selectNotaryId: (args as Map)['selectNotaryId'],
          notaryName: (args as Map)["notaryName"],
        ),
    // caseHandleShowPDF
    "caseHandleShowPDF": (BuildContext context, {Object args}) =>
        CaseHandleShowPDF(
          fileId: (args as Map)['fileId'],
          unitGuid: (args as Map)['unitGuid'],
          unionnotaritionid: (args as Map)['unionnotaritionid'],
          userName: (args as Map)['userName'],
          idCard: (args as Map)['idCard'],
          money: (args as Map)["money"],
          payStatus: (args as Map)["payStatus"],
          isOnlinePay: (args as Map)["isOnlinePay"],
          notaryName: (args as Map)["notaryName"],
        ),
    // signatureWidget
    "signatureWidget": (BuildContext context, {Object args}) => SignatureWidget(
        fileId: (args as Map)['fileId'], unitGuid: (args as Map)['unitGuid']),
    // notaryExtractWidget
    "notaryExtractWidget": (BuildContext context, {Object args}) =>
        NotaryExtractWidget(
          unitGuid: (args as Map)['unitGuid'],
          unionnotaritionid: (args as Map)['unionnotaritionid'],
          userName: (args as Map)['userName'],
          idCard: (args as Map)['idCard'],
          notaryName: (args as Map)["notaryName"],
        ),
    'faceCompare': (BuildContext context, {Object args}) => FaceCompareWidget(
          data: args,
        ),
    'webViewWidget': (BuildContext context, {Object args}) => WebViewPageWidget(
          title: (args as Map)['title'],
          url: (args as Map)['url'],
        ),
    "faceCompareIdentifyWidget": (BuildContext context, {Object args}) =>
        FaceCompareIdentifyWidget(
          orderId: (args as Map)['orderId'],
        ),
    "cashierDesk": (BuildContext context, {Object args}) => CashierDeskPage(
          money: (args as Map)['money'],
          orderNumber: (args as Map)['orderNumber'],
        ),
    "ElectronicNotarialCertificate": (BuildContext context, {Object args}) =>
        ElectronicNotarialCertificate(
          unitGuid: (args as Map)['unitGuid'],
        ),
    "VideoUnfinished":(BuildContext context, {Object args}) => VideoUnfinishedPage(
      comeFrom: (args as Map)['comeFrom'],
    ),
    "mySignatureSetting": (BuildContext context, {Object args}) =>
        MySignatureSettingPage(),
    "mySignatureApply": (BuildContext context, {Object args}) =>
        MySignatureApplyPage(
          isUpdate: (args as Map)['isUpdate'],
          entity: (args as Map)['entity'],
        ),
    "flutterInappwebview" :  (BuildContext context, {Object args}) =>
        FlutterInappwebviewPage(
          url: (args as Map)['url'],
          title: (args as Map)['title'],
        ),
    // "LoginTypeFile": (BuildContext context, {Object args}) =>
    //     LoginTypeFile(arguments: args)
  };

  //单例模式
  static Router _singleton;

  Router._internal();

  factory Router() {
    if (_singleton == null) {
      _singleton = Router._internal();
    }
    return _singleton;
  }

  //路由监听
  static Route<dynamic> getRoutes(RouteSettings settings) {
    String routeName = settings.name;
    final Function builder = Router._routes[routeName];
    wjPrint("CurrentPage：$settings");
    G.currentPath = settings.name;

    if (builder == null) {
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                  child: Text('没有找到对应的页面：${settings.name}'),
                ),
              ));
    } else {
      return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) =>
              builder(context, args: settings.arguments));
    }
  }
}
