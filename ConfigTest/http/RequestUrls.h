//
//  RequestUrls.h
//  HMPhealth
//
//  Created by ZhouYuan on 15/7/21.
//  Copyright (c) 2015年 ZhouYuan. All rights reserved.
//

#ifndef KaiWuHealth_RequestUrls_h
#define KaiWuHealth_RequestUrls_h

#ifdef DEBUG

//测试
#define kServerRootURL @"https://goldsgym.ag-2.qa.netpulse.com"

//生产机
//#define kServerRootURL @"http://jjkk.health.taikang.com/"
//

#else

//外网测试公司
//#define kServerRootURL @"http://office.aragoncs.com:8080/"
// 测试
#define kServerRootURL @"http://jjkktest.health.taikang.com/"
//生产机
//#define kServerRootURL @"http://jjkk.health.taikang.com/"


#endif





#define kAccountBaseInfoUrl [kServerRootURLAppendParams stringByAppendingString:@"user.do"]

#define kServerRootURLAppendParams [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/"]

#define kServerAPPURL [kServerRootURL stringByAppendingString:@"jjkk"]

// 客服电话
#define PhoneNumber @"tel://400-910-5522"
//

//逛逛用户的用户名和密码
#define kWalkName @"11111111111"
#define kWalkPwd @"111111"

// 服务协议
#define kProtocolUrl [kServerRootURL stringByAppendingString:@"jjkk/html/account/privacy_policy.html"]

//登录
#define kAccountLoginUrl [kServerRootURLAppendParams stringByAppendingString:@"login.do"]

//提交体检客户五要素
#define kCheckUserVIPInfoUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
//获取体检机构列表接口
#define kGetInstitutionListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
//提交体检卡预约接口
#define kSaveMedicalExaminationCardUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
//获取体检机构对应套餐接口
#define kgetHealthComboDescribeUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
//获取对应套餐对应套餐详情接口
#define kgetHealthComboListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
//获取所选城市对应的体检中心接口
#define kgetNodeByCityUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]

//获取体检机构体检时间接口
#define kgetNodeCalendarUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
#define ksaveBookingInfoUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
#define kcancelBookingUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
#define kgetCityUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
#define kmessagePushSetUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/message.do"]
// 获取预约列表
#define KGetPersonBookListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
// 跟新预约了列表状态

// 获取预约详情
#define KGetPersonBookDetailUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
// 取消预约
#define KCancelPersonBookUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]

// 我的预约评价
#define KEvaluatePersonBookUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]
// 获取预约评价
#define KGetEvaluateBookUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/medicalExaminationBooking.do"]

//获取消息列表
#define GetMessageListURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/message.do"]
//标记消息已读
#define MarkReadURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/message.do"]
// 标记所有已读
#define MarkReadAllUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/message.do"]
//删除消息
#define DeleteMessageListURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/message.do"]
// 删除所有消息
#define DeleteAllMessageListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/message.do"]


// 首页轮播图片ok
#define kHomeBannerImageUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]

//健康计划列表ok
#define kHomeHealthPlanListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthPlan.do"]

//完成健康计划任务
#define kHomeDoneHealthPlanListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthPlan.do"]
//添加健康计划
#define kAddHealthPlanListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthPlan.do"]

//删除健康计划
#define kDeleteHealthPlanListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthPlan.do"]

//编辑健康计划
#define kEditHealthPlanListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthPlan.do"]

//健康风险评估
#define kHomeHealthRisksUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/assess.do"]

//中医体质评估问题
#define kMedicineQuestionListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/evaOfTraChiMedicine.do"]

//中医体质评估结果
#define kMedicineResultListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/evaOfTraChiMedicine.do"]
//
#define kGetSolarTermResultUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/evaOfTraChiMedicine.do"]
//获取评测结果
#define kGetResultListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health /evaOfTraChiMedicine.do"]
//健康风险评估
#define kHealthRisksUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthRisks.do"]
//代谢综合症
#define kMetabolicSyndromeUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/assess.do"]
//糖尿病
#define kDiabetesUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/assess.do"]
//缺血性心血管疾病
#define kIcdUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/assess.do"]
//高血压
#define kHbpUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/assess.do"]
//获取慢病已有体检数据
#define kChronicQAUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/chronicQuestion.do"]

//PM 2.5 ok
#define kGetCityPMRequestUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/airNowAction.do"]
//PM 2.5 建议和影响 ok
#define kGetCityPMAffectAndMeasureUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/airNowAction.do"]

// 节气养生
#define kHomeHealthPreserveUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/evaOfTraChiMedicine.do"]

// 健康评估
#define kHomeHealthEvaluateUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/evaOfTraChiMedicine.do"]

// 我的测评 ok
#define kMyTestReportUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/myAssess.do"]
// 我的测评结果状态 ok
#define kMyTestReportStateUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/mainPage.do"]

// 产品激活 ok
#define kActiveProductUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/userbase.do"]
// 我的收藏 ok
#define kMyCollectionUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]


// 我的服务 ok
#define kMyServiceUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/userbase.do"]

// 个人中心保存用户信息 ok
#define kPersonInfomationUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/userbase.do"]

// 个人中心获取用户信息 ok
#define kGetPersonInfomationUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/userbase.do"]


// 症状列表 ok
#define kStateListUrl [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthAutognosis.do"]
// 症状列表问题 ok
#define kStateListQuestionURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthAutognosis.do"]

// 个人中心修改密码 ok
#define kPersonInfoFixPwdURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/userbase.do"]
//11.11个人中心修改头像
#define kPersonInfoFixImgURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/userbase.do"]

// 获取验证码 ok
#define kGetVicateCodeURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/login.do"]

//获取资讯头条接口 ok
#define kGetHeaderHealthMessageListURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]
//获取资讯列表接口 ok
#define kGetHealthMessageListURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]
//获取资讯详情列表接口
#define kGetHealthMessageDetialURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]

//添加收藏资讯接口
#define kAddCollectMessageURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]
//取消收藏资讯接口
#define kCancelCollectMessageURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]

//获取banner详情
#define kGetBannerMessageDetailURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]
//添加banner收藏
#define kAddBannerCollectMessageURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]
//取消banner收藏
#define kCancelBannerCollectMessageURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/health/healthmessage.do"]

// 资讯详情接口
#define kMessageDetailURL [kServerRootURL stringByAppendingString:@"jjkk/message/messagedetail.html?"]

// banner详情接口
#define kBannerMessageDetailURL [kServerRootURL stringByAppendingString:@"jjkk/message/bannerdetail.html?"]

//慢病风险评估结果
#define SlowDiseaseResultURL  [kServerRootURL stringByAppendingString:@"jjkk"]

//健康风险评估结果
#define HealthEvaluationResultURL  [kServerRootURL stringByAppendingString:@"jjkk"]

#define jkWriteReportURL [kServerRootURLAppendParams stringByAppendingString:@"structReport.do"]

//获取拍报告详情接口
#define GetTakeReportDetailInforURL [kServerRootURLAppendParams stringByAppendingString:@"photoReport.do"]
//保存报告图片
#define SaveTakeReportImageURL [kServerRootURL stringByAppendingString:@"jjkk/app/health/upload/imageUpload.do"]

//保存拍报告接
#define SaveTakeReportInforURL [kServerRootURLAppendParams stringByAppendingString:@"photoReport.do"]

//成员接口
#define MemberURL [kServerRootURLAppendParams stringByAppendingString:@"healthRecord.do"]

//pdf
#define PDFURL [kServerRootURLAppendParams stringByAppendingString:@"getPDF.do"]
// 获取个人信息首页预约消息数字
#define PersonOrderMemberURL [kServerRootURLAppendParams stringByAppendingString:@"userbase.do"]

// 获取我的档案对应的消息数
#define MyReportMemberURL [kServerRootURLAppendParams stringByAppendingString:@"healthRecord.do"]
// 获取我的档案列表
#define MyReportListURL [kServerRootURLAppendParams stringByAppendingString:@"healthRecord.do"]
// 获取我的档案详情-录报告
#define MyWriteReportDetailURL [kServerRootURLAppendParams stringByAppendingString:@"structReport.do"]
// 获取我的档案详情--派报告
#define MyPhotoReportDetailURL [kServerRootURLAppendParams stringByAppendingString:@"photoReport.do"]
// 获取我的档案详情
#define MyReportDetailURL [kServerRootURLAppendParams stringByAppendingString:@"healthRecord.do"]

// 获取体检百科列表
#define GetEncyclopediaListURL [kServerRootURLAppendParams stringByAppendingString:@"mainPage.do"]
// 获取体检百科所有2及页面数据
#define GetEncyclopediaSearchArrayURL [kServerRootURLAppendParams stringByAppendingString:@"mainPage.do"]

//我的慢病评估中获取体检机构名称和体检时间
#define GetInstitutionAndTimeURL [kServerRootURLAppendParams stringByAppendingString:@"chronicQuestion.do"]

#endif
