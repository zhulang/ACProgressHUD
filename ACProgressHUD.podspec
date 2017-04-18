
Pod::Spec.new do |s|
    s.name         = 'ACProgressHUD'
    s.version      = '0.0.3'
    s.summary      = 'An easy way to use pop-up box'
    s.homepage     = 'https://github.com/zhulang/ACProgressHUD'
    s.license      = 'MIT'
    s.authors      = {'Achilles_Chu' => '610730060@qq.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/zhulang/ACProgressHUD.git', :tag => s.version}
    s.source_files = 'ACProgressHUD/**/*.{h,m}'
    s.resource     = 'ACProgressHUD/ACProgressHUD.bundle'
    s.requires_arc = true
end
