server {
    listen      80;
    server_name  kjapi.aomygod.com user.aomygod.com wx.aomygod.com;
    charset utf8;
    #项目public目录
    root   /var/www/wx_aomygod_com/public/;
    index  index.html index.htm index.php;
    autoindex off;
#    access_log  /apps/log/php/accese.wx.aomygod.com.log;
#    error_log   /apps/log/php/error.wx.aomygod.com.log;
    #error_page   500 502 503 504  /error/502.html;

    #静态文件 statics|upload|autocrop|statics_admin
    location ~ ^/(statics|autocrop|statics_admin)(/|$) {
        #expires      10m;
    }
    location ~ .*\.(docx|htm|html|xml|swf|js|gif|jpg|jpeg|pjpeg|bmp|png|css|ico)?$ {
        #expires      10m;
    }

    #其它路径用PHP解释
    location ~ / {
      if ( !-e $request_filename  ) {
            rewrite ^/(.*)  /index.php last;
      }
      fastcgi_pass  php-upstream;
      fastcgi_index  index.php;
      include fastcgi_params;
      set $real_script_name $fastcgi_script_name;
      if ($fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
        set $real_script_name $1;
                set $path_info $2;
      }
        fastcgi_param SCRIPT_FILENAME $document_root$real_script_name;
        fastcgi_param CSPHP_SERV_EVN_TYPE   testing;
fastcgi_param SCRIPT_NAME $real_script_name;
        fastcgi_param PATH_INFO $path_info;

        include        /usr/local/nginx/conf/fastcgi.conf;
        include        /usr/local/nginx/conf/pathinfo.conf;
   }
}
