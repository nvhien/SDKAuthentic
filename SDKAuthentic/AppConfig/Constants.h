//
//  Constants.h
//  LaucherGame
//
//  Created by Ngo  Hien on 25/05/2021.
//

#ifndef Constants_h
#define Constants_h

#define FRAMEWORK_ENABLE                    1

typedef enum {
    LOGOUT,
    SIGNED_IN

} UserAction;


#define DATE_FORMAT                         @"dd/MM/yyyy"

#define USERNAME_INVALID                    @"Tên tài khoản không được chưa ký tự đặc biệt"
#define USERNAME_EMPTY                      @"Yêu cầu nhập tên tài khoản"
#define OLD_PASSWORD_EMPTY                  @"Yêu cầu nhập mật khẩu cũ"
#define PASSWORD_EMPTY                      @"Yêu cầu nhập mật khẩu"
#define PASSWORD_INVALID                    @"Mật khẩu phải có ít nhất 6 ký tự"
#define PASSWORD_CONFIRM_EMPTY              @"Yêu cầu xác nhận mật khẩu"
#define PASSWORD_NOT_MATCHING               @"Mật khẩu không trùng khớp"
#define SIGN_UP_SUCCESS                     @"Đăng ký tài khoản thành công"
#define SIGN_IN_FAIL                        @"Đăng nhập không thành công"
#define FEATURE_NOT_READY                   @"Chức năng đang được phát triển"
#define EMAIL_EMPTY                         @"Yêu cầu nhập email"
#define EMAIL_INVALID                       @"Email không đúng định dạng"
#define OTP_EMPTY                           @"Yêu cầu nhập mã OTP"
#define FULLNAME_EMPTY                      @"Yêu cầu nhập họ tên"
#define BIRTHDAY_EMPTY                      @"Yêu cầu chọn ngày tháng năm sinh"
#define CMND_NUMBER_INVALID                 @"Thông tin CMND không hợp lệ! Vui lòng nhập đúng số CMND (9 hoặc 12 số)"
#define USERNAME_OR_EMAIL_EMPTY             @"Yêu cầu nhập tên tài khoản hoặc email"

#endif /* Constants_h */
