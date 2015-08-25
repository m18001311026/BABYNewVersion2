//http request part
#define HttpRequestErrorDomain @"HttpRequestErrorDomain"
#define kHttpRequestTimeout 30.0f // Time out seconds.

//request part
#define CHANNEL @"1"
#define MD5KEY @"testmd5"
//#define SERVERURL @"http://115.28.136.139:8081/cms/service"
//下面是上线使用

#define SERVERURL @"http://115.28.136.139:8081/cms/service"


//#define SERVERURL @"http://192.168.0.3:8080/babyweb2/service"
// http://api.children-sketchbook.com/
//#define SERVERUR @"http://115.28.136.139:8083/babyweb/service"
//下面是上线使用

#define SERVERUR @"http://115.28.136.139:8081/cms/service"


//#define SERVERURL @"http://192.168.1.5:8080/baobei/service"
//下面是测试使用

//   http://192.168.0.3:8080/babyweb2/service
//#define SERVERURL @"http://192.168.0.3:8080/babyweb2/service"
//#define SERVERUR @"http://192.168.0.3:8080/babyweb2/service"

//image part
#define IMAGE_CACHE_FOLDER @"image"
#define IMAGE_CAHCE_MAX 50
#define IMAGE_SIZE_THREADHOLD 640*640

//voice part
#define VOICE_CACHE_FOLDER @"voice"

//video part
#define VIDEO_PREVIEW_BEGIN 16
#define VIDEO_PREVIEW_LENGTH 120

//other part
#define HOMEPAGE @"http://wsq.qq.com/reflow/251961196"
#define APPID @"873922966"
#define UMENGKEY @"53805dd056240b7bc4040d8b"

//notify part
#define NOTIFY_NEWGALLERYADD @"notify.gallery.add"

//page url
#define GALLERY_PAGE @"http://115.28.136.139:8081/babyweb/g4.jsp?id=%ld"
#define LESSON_PAGE @"http://115.28.136.139:8081/babyweb/g8.jsp?id=%ld"

//umeng event
#define UMENG_REGISTER_CHANNEL @"register_channel"
#define UMENG_SHARE_DEVICE @"share_device"
#define UMENG_SHARE_CONTENT @"share_content"
#define UMENG_SHARE_PLATFORM @"share_platform"
#define UMENG_BUY_AGE @"buy_age"
#define UMENG_BUY_LESSONTYPE @"buy_type"
#define UMENG_BUY_LESSONCNT @"buy_cnt"
#define UMENG_USER_YEAR @"user_year"
#define UMENG_USER_GENDER @"user_gender"


#define AppDownloadURL @"https://itunes.apple.com/cn/app/apple-store/id873922966?mt=8"