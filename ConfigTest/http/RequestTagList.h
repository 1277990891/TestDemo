//
//  RequestTagList.h
//  HMPDoctor
//
//  Created by ZhouYuan on 15/7/21.
//  Copyright (c) 2015年 ZhouYuan. All rights reserved.
//
#ifndef KaiWuHealth_RequestTagList_h
#define KaiWuHealth_RequestTagList_h

#define UserRegistAccountRequestTag 10011
#define UserLoginWithPasswordRequestTag 10012

#define UserSaveProfileInfoRequestTag 10013


// 个人信息
#define UserGetProfileInfoRequestTag 10014
// 重置密码
#define UserResetPasswordRequestTag 10015
//忘记密码
#define UserPassResetRequestTag 10017
// 验证码
#define UserGetVerificationCodeRequestTag 10016
// 更新sessionId
#define RefreshSessionRequestTag 10020

//预约模块
#define GetUserVIPInfoTag 20000
#define CheckUserVIPInfoTag 20001
#define GetInstitutionListTag 20002
#define SaveMedicalExaminationCardTag 20003
#define GetHealthComboListTag 20004
#define GetNodeByCityTag 20005
#define GetNodeCalendarTag 20006
#define SaveBookingInfoTag 20007
#define CancelBookingTag 20008
#define GetCityTag 20009
#define GetInstitutionTag 200010
//消息中心模块
#define GetMessageListTag 200011
//标记已读消息
#define MarkReadTag 200012
// 标记所有信息已读
#define MarkReadAllTag 200016
//删除消息列表
#define DeleteMessageListTag 200013
// 删除所有信息列表
#define DeleteAllMessageListTag 200015
#define MessagePushSetTag 200014

// 获取首页轮播图ok
#define HomeBannerImageRequestTag 10050

// 首页健康计划列表ok
#define HomeHealthPlanListRequestTag 10051

// 获取PM 2.5 ok
#define GetCityPMRequestTag 10052
// 获取PM 2.5 影响和建议 ok
#define GetCityPMAffectRequestTag 10058

// 节气养生
#define GetHealthPreserveRequestTag 10056

// 健康评估
#define GetHealthEvlauteRequestTag 10057

// 首页健康风险评估
#define HomeHealthRisksRequestTag 10053

// 是否从本地取
#define HomeBannerLocalRequestTag 10055

// 健康计划
#define AddHealthPlanRequestTag 10090
// 删除健康计划
#define DeleteHealthPlanRequestTag 10091
// 完成健康计划
#define DoneHealthPlanRequestTag 10092
// 编辑健康计划
#define EditeHealthPlanRequestTag 10093

// 我的测评 ok
#define GetMyTestReportRequestTag 10060
// 我的测评结果状态 ok
#define GetMyTestReportStateRequestTag 10067
// 产品激活 ok
#define ActiveProductUrlRequestTag 10061
// 我的收藏 ok
#define GetMyCollectionRequestTag 10062
// 我的服务 ok
#define GetMyServiceRequestTag 10063

// 个人中心保存用户信息 ok
#define SendPersonInfomationRequestTag 10064

// 个人中心获取用户信息 ok
#define GetPersonInfomationRequestTag 10065

// 置顶
#define SetTopMessageRequestTag 10066

// 症状列表 ok
#define GetStateListRequestTag 10070

// 症状列表问题 ok
#define GetStateListQuestionRequestTag 10071
// 个人中心修改密码 ok
#define GetPersonInfoFixPwdRequestTag 10072
//个人中心修改头像
#define GetPersonInfoFixImgdRequestTag 10073
//中医体质测评问题
#define GetMedicineTestQuestionRequestTag 10080
#define GetMedicineTestResultRequestTag 10081
#define GetSolarTermResultRequestTag 10082



//资讯列表
#define GetInfoListRequestTag 10100
//资讯头条
#define GetInfoHeaderRequesTag 10101
//资讯详情
#define GetInfoHeaderDetailRequesTag 10102
//资讯收藏
#define  GetInfoFavRequesTag 10103
//取消资讯收藏
#define  GetInfoDeleteFavRequesTag 10104

//banner收藏
#define  GetBannerFavRequesTag 10105
//取消banner收藏
#define  GetBannerDeleteFavRequesTag 10106


//banner详情
#define GetBannerDetailRequesTag 10107

/*  录报告   */
//获取科室列表
#define GetDepartmentListRequesTag 10200
//获取科室问卷
#define GetQuestionRequesTag 10201
//保存问卷答案
#define GetSaveAnswerRequesTag 10202
//获取问卷详情
#define GetAnswerDetailRequesTag 10203
//获取pdf
#define GetPDFRequesTag 10204

//调用泰康获取健康档案接口，将查询回来的体检报告列表插入到本地数据库中
#define GetRecordListTag 10210
//获取体检报告机构化数据
#define GetStructDataTag 10211
/*  拍报告  */
#define GetReportDetailInforTag 10300
/*获取基本信息*/
#define GetReportbaseInforTag 103003
#define SaveReportInforTag 103001
#define SaveReportInforImage 103002
#define DeleteReportInforImage 103004

/*  成员管理  */
#define AddMemberTag 10300
#define GetMemberTag 10301
#define DeleteMemberTag 10302
#define ChangeMemberTag 10303
#define GetHealthRecordTag 10304
#define DeleteHealthRecordTag 10305


/**
    个人中心
 */
// 获取预约列表信息
#define KGetPersonBookListTag  10500
// 获取预约列表信息详情
#define KGetPersonBookDetailTag  10501
// 取消预约
#define KCancelPersonBookTag  10502
// 获取我的档案对应的消息数
#define KGetPersonReportNumTag  10503
// 获取我的档案列表
#define KGetPersonReportListTag  10504
// 跟新获取预约列表信息状态
#define KGetBookListStatusTag 10603

// 获取我的档案对应的消息数
#define KGetPersonOrderNumTag  10506
// 获取百科列表
#define KGetEncyclopediaListTag  10505
// 我的预约评价
#define KGetEvaluateTag  10507
// 获取百科首页2及数据
#define KGetEvaluateArrayTag  10508
// 获取我的档案详情-录报告
#define KGetWriteReportDetailTag  10509
// 获取我的档案详情-派报告
#define KGetPhotoReportDetailTag  10511
// 获取我的档案详情-
#define KGetReportDetailTag  10512
// 获取我评价
#define KGetReportEvaluationTag  10510


#endif
