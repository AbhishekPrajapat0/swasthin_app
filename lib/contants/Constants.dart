//base url
const String base_url = "https://swasthin.connivia.com/api/";
// const String base_url = "http://swasthinlive.connivia.com/api/";

//auth
const String userLogInUrl = "customer/login";
const String userSignUpUrl = "customer/signup";

const String getStripeKeyUrl = "customer/key";

const String subscriptionStatusUrl = "customer/V1/package/status";
const String getStaffIdForChatUrl = "customer/V1/staff/chatid";

const String getCurrentBatchUrl = "customer/V1/current/batch";

//Otp
const String sendOtpUrl = "customer/otp/generate";
const String verifyOtpUrl = "customer/otp/verification";

const String checkUserPresenceUrl = "customer/check/registration";

//profile details
const String profileUpdateUrl = "customer/V1/profile/update";
const String profileStoreUrl = "customer/V1/profile/store";
const String getProfileInfoUrl = "customer/V1/profile/info";

const String getReportUploadedListUrl = "customer/V1/user/report";

// Allergies List Api
const String allergiesListUrl = "customer/allergy/list";

// banner
const String bannerListUrl = "customer/banner/list";

// Packages || subscription
// const String getPackageListUrl= "customer/V1/package";
const String getPackageListUrl = "customer/package";

const String selectPackageUrl = "customer/V1/packages";
const String checkPaymentStatusUrl = "customer/V1/package/update";
const String currentActivePlanUrl = "customer/V1/package/subscriptions";
const String plansBoughtListUrl = "customer/V1/package/subscriptions/list";
const String transactionHistoryUrl = "customer/V1/user/transaction/history";
const String paymentFailedUrl = "customer/V1/package/payment/fail";

const String getRenewPlanDetailsUrl = "customer/V1/renew/packages";

// const String getProgramsUrl= "customer/V1/program/explore/list";
const String getProgramsUrl = "customer/program/explore/list";

const String sendProgramsPrefUrl = "customer/V1/program/explore/store";

const String feedbackUrl = "customer/V1/rating";

// Terms and policys
const String termsAndConditionsUrl = "customer/terms-and-condition";
const String policiesUrl = "customer/privacy-policy";

//account delete
const String accountDeleteUrl = "customer/V1/account/delete";

// yoga Batches
const String getBatchListUrl = "customer/batch/list";
const String selectBatchUrl = "customer/V1/batch/add";
const String myClassesListUrl = "customer/V1/batch/user/list";
const String myClassDetailUrl = "customer/V1/batch/user/details";

//time slots
const String getTimeSlotsUrl = "customer/V1/call/request/time/slots?date=";
const String bookSlotUrl = "customer/V1/appointment";
const String appointmentListUrl = "customer/V1/appointment/list";
const String appointmentCancelUrl = "customer/V1/appointment/call/cancel";

// forgot password
const String resetPassUrl = "customer/forgot/password";

const String callLogUrl = "customer/V1/calllog/list";

//chat
const String addChatUrl = "customer/V1/chat";
const String chatHistoryUrl = "customer/V1/chat/message/list";
const String chatMsgUpdateUrl = "customer/V1/chat/msgupadte";
const String chatWithListUrl = "customer/V1/chat/list";

const String dietDateUrl = "customer/V1/diet/date/list";
const String dietDateDetailUrl = "customer/V1/diet/date/";

const String dietFollowedFeedbackUrl = "customer/V1/diet/feedback";

// storage keys
const String loginToken = "token";
const String loggedIn = "isUserLoggedIn";

const String dayLeftFromExpiry = "day_left_from_expiry";

const String isSubscribed = "isSubscribed";

const String batchSelected = "batch_selected";

const String userProfileStatus = "user_profile_status";

const String userName = "user_name";
const String userMobileNum = "user_number";
const String userEmail = "user_email";
const String userID = "user_id";
const String userGender = "user_gender";
const String userWeight = "user_weight";
const String userIdealWeight = "user_ideal_weight";
const String userIdealKcals = "user_ideal_kcals";
const String userHeight = "user_height";
const String userActivityLevel = "user_activity_level";
const String userGoal = "user_goal";
const String userDietPref = "user_diet_pref";
const String userDOB = "user_DOB";
const String userAge = "user_age";

// chat
const String currentStaffIdForChat = "staff_if_for_chat";
const String chatStartDate = "start_chat_date";
const String msgCountDashboard = "message_count";

const String dietitianName = "dietitian_name";

// Dashboard
const String featuresAvail = "features_available";
